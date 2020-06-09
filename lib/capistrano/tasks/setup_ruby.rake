namespace :rbenv do
  RBENV_REPO_URL = 'https://github.com/rbenv/rbenv.git'.freeze
  RUBY_BUILD_REPO_URL = 'https://github.com/rbenv/ruby-build.git'.freeze

  desc 'Install ruby dependencies'
  task :install_ruby_deps do
    on roles(fetch(:rbenv_role)) do
      execute "#{fetch(:rbenv_ruby_deps_installler)} #{fetch(:rbenv_ruby_deps)}"
    end
  end

  desc 'Install rbenv'
  task :install do
    on roles(fetch(:rbenv_role)) do
      next if test "[ -d #{fetch(:rbenv_path)} ]"

      invoke 'rbenv:install_ruby_deps'
      execute :git, "clone #{RBENV_REPO_URL} #{fetch(:rbenv_path)}"
    end
  end

  desc 'Install/Update ruby-build - rbenv plugin'
  task :install_ruby_build do
    on roles(fetch(:rbenv_role)) do
      ruby_build_path = "#{fetch(:rbenv_path)}/plugins/ruby-build"

      if test "[ -d #{ruby_build_path} ]"
        execute :git, "-C #{ruby_build_path} pull"
      else
        execute :git, "clone #{RUBY_BUILD_REPO_URL} #{ruby_build_path}"
      end
    end
  end

  desc 'Install ruby'
  task :install_ruby do
    on roles(fetch(:rbenv_role)) do
      next if test "[ -d #{fetch(:rbenv_ruby_dir)} ]"

      invoke 'rbenv:install'
      invoke 'rbenv:install_ruby_build'
      execute :rbenv, "install #{fetch(:rbenv_ruby)}"
    end
  end
end
