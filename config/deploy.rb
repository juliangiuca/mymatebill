require 'capistrano/ext/multistage'

# SET THE APPLICATION NAME
set :application, "mymatebill"

#General common variables to be set
set :scm, 'git'
set :deploy_via, :export
set :user, "www"
set :password, "cGQW44ZRXItY"
set :scm_username, "www"
set :runner, nil
set :use_sudo, false

# We can deploy a particular branch or tag by
# cap deploy -Sbranch=1.0
# cap deploy -Stag=1.0.6
set :repository, "git@foochr.com:manage.git"  # Your clone URL

# Apache phusion integration - this will restart the server. Ensure server side is configured to use phusion not mongrels.
namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    puts "Restarting application"
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Restart Daemons"
  task :restart_daemons, :roles => :daemon do
    puts "Restarting daemons..."
    run "cd #{current_path}; RAILS_ENV=#{fetch(:stage).to_s} rake site:feeds:stop"
    run "cd #{current_path}; RAILS_ENV=#{fetch(:stage).to_s} rake site:feeds:start"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

namespace :config do
  task :database_yml, :roles => :app do
    run "cp #{release_path}/config/database.#{fetch(:stage).to_s}.yml #{shared_path}/database.yml"
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:symlink", "config:database_yml"

