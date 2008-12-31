set :application, "helpishere"
set :domain, "helpishere.org"
set :deploy_to,   "/home/stronwi/public_html/#{application}"
set :scm,         "git"

# use the following with a private repos
# set :repository,  "git@github.com:user/appname.git"

# use the following with a public repos
set :repository,   "git@github.com:jlippiner/helpishere.git"

set :mongrel_port, 8070
set :mongrel_servers, 2

namespace :vlad do
  desc 'Runs vlad:update, vlad:symlink, vlad:migrate and vlad:start'
  task :deploy => ['vlad:update', 'vlad:symlink', 'vlad:migrate', 'vlad:stop_app', 'vlad:start_app']

  desc 'Symlinks your custom directories'
  remote_task :symlink, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{current_release}/config/database.yml"
  end
end
