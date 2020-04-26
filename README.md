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

Following is the list of all optional configurable options along with their default values.

```ruby
# Set rbenv installation type (user/system)
set :rbenv_type, :user

# Set rbenv installation path
set :rbenv_path, '$HOME/.rbenv'

# Set customs bins to create under rbenv
set :rbenv_map_bins, %w[rake gem bundle ruby rails]

# Set list of custom dependencies to install
set :rbenv_deps, ''

# Set list of default dependencies to install
set :rbenv_default_deps, 'libssl-dev zlib1g-dev libreadline-dev build-essential'

# Set dependencies installer
set :rbenv_deps_installler, 'apt-get install -y'
```

When you `require 'capistrano/rbenv'` in your Capfile, it will add default hooks to capistrano deploy that will automatically setup everything (rbenv, ruby, bundler) you need. If you want to skip the default hooks and setup everything on your own, use the following instructions,

```ruby
# Capfile
require 'capistrano/rbenv/without_hooks'


# Inside your custom capistrano tasks
after :some_task, 'rbenv:setup'

# Or like this
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
rbenv:setup                # Setup rbenv, ruby and bundler
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uxxman/capify-rbenv.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
