# Capify::Rbenv

Capistrano recipes to setup rbenv, ruby and bundler. It provides all the goodies of [capistrano-rbenv](https://github.com/capistrano/rbenv) and adds more features, like:

* Install [rbenv](https://github.com/rbenv/rbenv) if not installed already.
* Install [ruby-build](https://github.com/rbenv/ruby-build) if not installed already.
* Install specified ruby version if not installed already.
* Install specified bundler version if not installed already.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.13'
gem 'capify-rbenv', '~> 5.0'
```

And then execute:

```shell
$ bundle install
```

## Usage

```ruby
# Capfile
require 'capistrano/rbenv'
install_plugin Capistrano::Rbenv # Required: Setup rbenv
install_plugin Capistrano::Rbenv::SetupRuby # Optional: Install/Setup ruby 
install_plugin Capistrano::Rbenv::SetupBundler # Optional: Install/Setup bundler


# config/deploy.rb
set :rbenv_ruby, '2.7.1' # Set ruby version to use
set :rbenv_bundler, '2.1.4' # Set bundler version to use

# In case you want to set ruby version from .ruby-version file:
# set :rbenv_ruby, File.read('.ruby-version').strip
```

Following is the list of all optional configurable options along with their default values and examples.

```ruby
# Set role on which rbenv setup will apply
set :rbenv_role, :app

# Set rbenv installation type (user/system)
set :rbenv_type, :user

# Set rbenv installation path
set :rbenv_path, fetch(:rbenv_type) == :system ? '/usr/local/rbenv' : '$HOME/.rbenv'

# Set rbenv directory for installed ruby versions
set :rbenv_ruby_dir, "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}"

# Set or append the list of dependencies to install
# See lib/capistrano/tasks/defaults.rake for default dependencies
append :rbenv_ruby_deps, 'libsqlite3-dev', 'sqlite3'

# Set dependencies installer
set :rbenv_ruby_deps_installler, 'apt-get install -y'

# Set or append customs bins to create under rbenv
# See lib/capistrano/tasks/defaults.rake for default bins
append :rbenv_map_bins, 'puma', 'pumactl'
```

## Available tasks

```ruby
rbenv:install              # Install rbenv
rbenv:map_bins             # Map binaries to rbenv path
rbenv:install_ruby         # Install ruby
rbenv:install_bundler      # Install bundler gem
rbenv:install_ruby_build   # Install/Update ruby_build - rbenv plugin
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uxxman/capify-rbenv.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
