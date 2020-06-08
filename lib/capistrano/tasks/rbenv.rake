namespace :rbenv do
  RBENV_REPO_URL = 'https://github.com/rbenv/rbenv.git'.freeze
  RUBY_BUILD_REPO_URL = 'https://github.com/rbenv/ruby-build.git'.freeze


  desc 'Install rbenv'
  task :install do
    on roles(fetch(:rbenv_role)) do
      next if test "[ -d #{fetch(:rbenv_path)} ]"

      execute :sudo, "#{fetch(:rbenv_deps_installler)} #{fetch(:rbenv_default_deps)} #{fetch(:rbenv_deps)}"
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
        invoke 'rbenv:install'
        execute :git, "clone #{RUBY_BUILD_REPO_URL} #{ruby_build_path}"
      end
    end
  end


  desc 'Install ruby'
  task :install_ruby do
    on roles(fetch(:rbenv_role)) do
      next if test "[ -d #{fetch(:rbenv_ruby_dir)} ]"

      invoke 'rbenv:install_ruby_build'
      execute :rbenv, "install #{fetch(:rbenv_ruby)}"
    end
  end


  desc 'Install bundler'
  task :install_bundler do
    on roles(fetch(:rbenv_role)) do
      next if test :gem, :query, "-q -i -n ^bundler$ -v #{fetch(:rbenv_bundler)}"

      invoke 'rbenv:install_ruby'
      execute "echo 'gem: --no-document' >> ~/.gemrc"
      execute :gem, :install, :bundler, "-v #{fetch(:rbenv_bundler)}"
    end
  end


  desc 'Setup rbenv, ruby-build, ruby and bundler'
  task :setup do
    invoke 'rbenv:install_bundler'
  end
end
