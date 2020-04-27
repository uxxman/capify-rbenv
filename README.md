# Capify::Rbenv

Capistrano recipes to setup rbenv, ruby and bundler.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.13'
gem 'capify-rbenv', '~> 1.0'
```

And then execute:

```shell
$ bundle install
```

## Usage

```ruby
# Capfile
require 'capistrano/rbenv'


# config/deploy.rb
set :rbenv_ruby, '2.7.1' # Set ruby version to install (Required)
set :rbenv_bundler, '2.1.4' # Set bundler version to install (Required)

# In case you want to set ruby version from .ruby-version file:
# set :rbenv_ruby, File.read('.ruby-version').strip
```

Following is the list of all optional configurable options along with their default values and examples.

```ruby
# Set rbenv installation type (user/system)
set :rbenv_type, :user

# Set rbenv installation path
set :rbenv_path, fetch(:rbenv_type) == :system ? '/usr/local/rbenv' : '$HOME/.rbenv'

# Set rbenv directory for installed ruby versions
set :rbenv_ruby_dir, "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}"

# Set or append the list of dependencies to install
# See lib/capistrano/tasks/defaults.rake for default dependencies
append :rbenv_deps, 'libsqlite3-dev', 'sqlite3'

# Set dependencies installer
set :rbenv_deps_installler, 'apt-get install -y'

# Set or append customs bins to create under rbenv
# See lib/capistrano/tasks/defaults.rake for default bins
append :rbenv_map_bins, 'puma', 'pumactl'
```

When you `require 'capistrano/rbenv'` in your Capfile, it will add default hooks to capistrano deploy that will automatically setup everything (rbenv, ruby, bundler) you need. If you want to skip the default hooks and setup everything on your own, use the following instructions,

```ruby
# Capfile
require 'capistrano/rbenv/without_hooks'


# Then add it as a hook
after :some_task, 'rbenv:setup'

# Or invoke manually
task :custom_setup do
  invoke 'rbenv:setup'
end
```

## Available tasks

```ruby
rbenv:install              # Install rbenv
rbenv:install_ruby         # Install ruby
rbenv:install_bundler      # Install bundler gem
rbenv:install_ruby_build   # Install/Update ruby_build - rbenv plugin
rbenv:setup                # Setup rbenv, ruby-build, ruby and bundler
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uxxman/capify-rbenv.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
