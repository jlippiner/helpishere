class AdminController < ApplicationController
  def index
    config   = Rails::Configuration.new
    @host     = config.database_configuration[RAILS_ENV]["host"]
    @database = config.database_configuration[RAILS_ENV]["database"]
    @db_username = config.database_configuration[RAILS_ENV]["username"]
    @db_password = config.database_configuration[RAILS_ENV]["password"]


    @users = User.find(:all)
  end

end
