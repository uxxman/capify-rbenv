module Capistrano::Rbenv
  class SetupBundler < Capistrano::Plugin
    def define_tasks
      eval_rakefile File.expand_path('../../tasks/setup_bundler.rake', __dir__)
    end

    def register_hooks
      after 'rbenv:install_ruby', 'rbenv:install_bundler'
    end

    def set_defaults
      # Set bundler version to use/install
      set_if_empty :rbenv_bundler, '2.1.4'
    end
  end
end
