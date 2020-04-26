namespace :rbenv do
  desc 'Install rbenv'
  task :install do
    on roles(:app) do
      next if test "[ -d #{fetch(:rbenv_path)} ]"

      repo_url = 'https://github.com/rbenv/rbenv.git'
      dependencies = "#{fetch(:rbenv_default_deps)} #{fetch(:rbenv_deps)}"

      execute :sudo, fetch(:rbenv_deps_installler), dependencies
      execute :git, :clone, repo_url, fetch(:rbenv_path)
    end
  end


  desc 'Install/Update ruby_build - rbenv plugin'
  task :install_ruby_build do
    on roles(:app) do
      repo_url = 'https://github.com/rbenv/ruby-build.git'
      ruby_build_path = "#{fetch(:rbenv_path)}/plugins/ruby-build"

      if test "[ -d #{ruby_build_path} ]"
        execute :git, "-C #{ruby_build_path} pull"
      else
        execute :git, :clone, repo_url, ruby_build_path
      end
    end
  end


  desc 'Install ruby'
  task :install_ruby do
    on roles(:app) do
      next if test "[ -d #{fetch(:rbenv_ruby_dir)} ]"

      invoke 'rbenv:install'
      invoke 'rbenv:install_ruby_build'

      execute :rbenv, :install, fetch(:rbenv_ruby)
    end
  end


  desc 'Install bundler gem'
  task :install_bundler do
    on roles(:app) do
      next if test :gem, :query, "-q -i -n ^bundler$ -v #{fetch(:rbenv_bundler)}"

      execute "echo 'gem: --no-document' >> ~/.gemrc"
      execute :gem, :install, :bundler, "-v #{fetch(:rbenv_bundler)}"
    end
  end


  task :map_bins do
    SSHKit.config.default_env.merge!({ rbenv_root: fetch(:rbenv_path), rbenv_version: fetch(:rbenv_ruby) })
    SSHKit.config.command_map[:rbenv] = "#{fetch(:rbenv_path)}/bin/rbenv"
    rbenv_prefix = fetch(:rbenv_prefix, "#{fetch(:rbenv_path)}/bin/rbenv exec")

    fetch(:rbenv_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(rbenv_prefix)
    end
  end


  desc 'Setup ruby and bundler'
  task :setup do
    invoke 'rbenv:map_bins'
    invoke 'rbenv:install_ruby'
    invoke 'rbenv:install_bundler'
  end
end
