module Capistrano
  class Rbenv::SetupRuby < Plugin
    def define_tasks
      eval_rakefile File.expand_path('../tasks/setup_ruby.rake', __dir__)
    end

    def register_hooks
      after 'rbenv:map_bins', 'rbenv:install_ruby'
    end

    def set_defaults
      # Set rbenv directory for installed ruby versions
      set_if_empty :rbenv_ruby_dir, "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}"

      # Set list of dependencies needed for ruby
      set_if_empty :rbenv_ruby_deps, %w[libssl-dev zlib1g-dev libreadline-dev build-essential]

      # Set dependencies installer
      set_if_empty :rbenv_ruby_deps_installler, 'sudo apt-get install -y'
    end
  end
end
