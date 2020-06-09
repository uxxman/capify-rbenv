namespace :rbenv do
  desc 'Install bundler'
  task :install_bundler do
    on roles(fetch(:rbenv_role)) do
      next if test :gem, :query, "-q -i -n ^bundler$ -v #{fetch(:rbenv_bundler)}"

      execute "echo 'gem: --no-document' >> ~/.gemrc"
      execute :gem, "install bundler -v #{fetch(:rbenv_bundler)}"
    end
  end
end
