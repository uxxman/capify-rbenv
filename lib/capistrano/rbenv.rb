module Capistrano
  class Rbenv < Plugin
    def define_tasks
      eval_rakefile File.expand_path('tasks/rbenv.rake', __dir__)
    end

    def register_hooks
      Capistrano::DSL.stages.each do |stage|
        after stage, 'rbenv:map_bins'
      end
    end

    def set_defaults
      # Set role on which rbenv setup will apply
      set_if_empty :rbenv_role, :app

      # Set rbenv installation type (user/system)
      set_if_empty :rbenv_type, :user

      # Set ruby version to use/install
      set_if_empty :rbenv_ruby, '2.7.1'

      # Set rbenv installation path
      set_if_empty :rbenv_path, fetch(:rbenv_type) == :system ? '/usr/local/rbenv' : '$HOME/.rbenv'

      # Set customs bins to create under rbenv
      set_if_empty :rbenv_map_bins, %i[gem rake ruby rails bundle bundler]
    end
  end
end

require_relative 'rbenv/setup_ruby'
require_relative 'rbenv/setup_bundler'
