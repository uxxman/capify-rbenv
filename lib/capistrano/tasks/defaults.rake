namespace :load do
  task :defaults do
    default_deps = %w[
      libssl-dev
      zlib1g-dev
      libreadline-dev
      build-essential
    ]

    # Set rbenv installation type (user/system)
    set :rbenv_type, fetch(:rbenv_type, :user)

    # Set ruby version to install using rbenv (Required)
    # set :rbenv_ruby, '2.7.1'

    # Set bundler version to install using rbenv (Required)
    # set :rbenv_bundler, '2.1.4'

    # Set rbenv installation path
    set :rbenv_path, fetch(:rbenv_type) == :system ? '/usr/local/rbenv' : '$HOME/.rbenv'

    # Set rbenv directory for installed ruby versions
    set :rbenv_ruby_dir, "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}"

    # Set customs bins to create under rbenv
    set :rbenv_map_bins, %w[rake gem bundle ruby rails]

    # Set list of custom dependencies to install
    set :rbenv_deps, fetch(:rbenv_deps, '')

    # Set list of default dependencies to install
    set :rbenv_default_deps, fetch(:rbenv_default_deps, default_deps.join(' '))

    # Set dependencies installer
    set :rbenv_deps_installler, fetch(:rbenv_deps_installler, 'apt-get install -y')
  end
end


Capistrano::DSL.stages.each do |stage|
  after stage, :rbenv_map_bins do
    SSHKit.config.default_env.merge!({ rbenv_root: fetch(:rbenv_path), rbenv_version: fetch(:rbenv_ruby) })
    SSHKit.config.command_map[:rbenv] = "#{fetch(:rbenv_path)}/bin/rbenv"
    rbenv_prefix = fetch(:rbenv_prefix, "#{fetch(:rbenv_path)}/bin/rbenv exec")

    fetch(:rbenv_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(rbenv_prefix)
    end
  end
end
