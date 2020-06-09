namespace :rbenv do
  desc 'Map binaries to rbenv path'
  task :map_bins do
    SSHKit.config.default_env.merge!({ rbenv_root: fetch(:rbenv_path), rbenv_version: fetch(:rbenv_ruby) })
    SSHKit.config.command_map[:rbenv] = "#{fetch(:rbenv_path)}/bin/rbenv"

    fetch(:rbenv_map_bins).uniq.each do |cmd|
      SSHKit.config.command_map.prefix[cmd].unshift("#{fetch(:rbenv_path)}/bin/rbenv exec")
    end
  end
end
