namespace :staging do
  desc "Push to staging environment"
  task :deploy do
    ssh_command = "ssh hih_staging"
    user        = "helpishere"
    branch      = "master"
    revision    = ENV["revision"] || "HEAD"
    application = "helpishere"

    puts "updating application"
    %x{#{ssh_command} "cd ~/shared/#{user}&& git checkout master && git pull origin master"}

    puts "syncing application"
    %x{#{ssh_command} "rsync -avg --exclude='.git/*' ~/shared/#{user}/ /home/#{user}/current && echo '#{branch}/#{revision}' > ~/current/RELEASE"}

    puts "linking database.yml"
    %x{#{ssh_command} "ln -nfs ~/shared/config/database.yml ~/current/config/database.yml"}

    puts "linking keys.rb"
    %x{#{ssh_command} "ln -nfs ~/shared/config/keys.rb ~/current/config/keys.rb"}

    puts "linking log directory"
    %x{#{ssh_command} "ln -nfs ~/shared/log ~/current/log"}

    puts "linking assets directory"
    %x{#{ssh_command} "ln -nfs ~/shared/assets ~/current/public/assets"}

    puts "stopping mongrel"
    %x{#{ssh_command} "source ~/.profile &&  mongrel stop"}

    puts "starting mongrel"
    %x{#{ssh_command} "source ~/.profile &&  mongrel start"}
  end
end

namespace :production do
  desc "Push to production environment"
  task :deploy do
    set :deploy_to, "/home/stronwi/public_html/helpishere"
    set :application, "helpishere"
    set :domain, "helpishere.org"
    set :repository, 'http://github.com/jlippiner/helpishere/tree/master'
  end

  task :go_live do
    ssh_command = "ssh hih_production"
    user        = "stronwi"
    branch      = "master"
    revision    = ENV["revision"] || "HEAD"
    application = "helpishere"
    deploy_to   = "public_html/helpishere"

    puts "updating application"
    %x{#{ssh_command} "cd /home/#{user}/shared/ && git checkout master && git pull github master"}

    puts "syncing application"
    %x{#{ssh_command} "rsync -avg --exclude='.git/*' ~/shared/ /home/#{user}/current && echo '#{branch}/#{revision}' > ~/current/RELEASE"}

    puts "linking database.yml"
    %x{#{ssh_command} "ln -nfs ~/shared/config/database.yml ~/current/config/database.yml"}

    puts "linking keys.rb"
    %x{#{ssh_command} "ln -nfs ~/shared/config/keys.rb ~/current/config/keys.rb"}

    puts "linking log directory"
    %x{#{ssh_command} "ln -nfs ~/shared/log ~/current/log"}

    puts "linking assets directory"
    %x{#{ssh_command} "ln -nfs ~/shared/assets ~/current/public/assets"}

    puts "stopping mongrel"
    %x{#{ssh_command} "source ~/.profile &&  mongrel stop"}

    puts "starting mongrel"
    %x{#{ssh_command} "source ~/.profile &&  mongrel start"}
  end
end
