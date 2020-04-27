namespace :load do
  task :defaults do
    default_deps = %w[
      libpq-dev
      libssl-dev
      zlib1g-dev
      libreadline-dev
      build-essential
    ]

    default_bins = %w[
      gem
      rake
      ruby
      rails
      bundle
    ]

    # Set ruby version to install using rbenv (Required)
    # set :rbenv_ruby, '2.7.1'

    # Set bundler version to install using rbenv (Required)
    # set :rbenv_bundler, '2.1.4'

    # Set rbenv installation type (user/system)
    set_if_empty :rbenv_type, :user

    # Set rbenv installation path
    set_if_empty :rbenv_path, fetch(:rbenv_type) == :system ? '/usr/local/rbenv' : '$HOME/.rbenv'

    # Set rbenv directory for installed ruby versions
    set_if_empty :rbenv_ruby_dir, "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}"

    # Set list of custom dependencies to install
    set_if_empty :rbenv_deps, default_deps.join(' ')

    # Set dependencies installer
    set_if_empty :rbenv_deps_installler, 'apt-get install -y'

    # Set customs bins to create under rbenv
    set_if_empty :rbenv_map_bins, default_bins.join(' ')
  end
end


Capistrano::DSL.stages.each do |stage|
  after stage, :rbenv_map_bins do
    SSHKit.config.default_env.merge!({ rbenv_root: fetch(:rbenv_path), rbenv_version: fetch(:rbenv_ruby) })
    SSHKit.config.command_map[:rbenv] = "#{fetch(:rbenv_path)}/bin/rbenv"
    rbenv_prefix = fetch(:rbenv_prefix, "#{fetch(:rbenv_path)}/bin/rbenv exec")

    fetch(:rbenv_map_bins).uniq.each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(rbenv_prefix)
    end
  end
end
