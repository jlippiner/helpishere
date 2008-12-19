class UserController < ApplicationController
layout proc{ |c| c.request.xhr? ? false : "application" }
  
  
  def logout
    session[:user_id] = @current_user = nil
    flash[:notice]="You are now logged out."
    render :action => "login"
  end

  def index
    
  end
  
  def login
    return if params[:login].to_s.nilemp? or params[:password].to_s.nilemp?
    
    @current_user = User.find_by_email_and_password(params[:login], params[:password])

    if @current_user
      session[:user_id]=@current_user.id
      redirect_to user_index_path
    else
      flash[:notice]="Invalid email or password.  Please try again"
      render :action => "login"
    end
  end

  def join
    @user = User.new(params[:user])
    if @user.save
      if session[:search_id]
        @search = Search.find(session[:search_id])
        @profile = Profile.new
        @profile.create_from_search(@search,'Default')
        @profile.save
      end
      respond_to do |format|
        format.js {
          render :text => "redirect('/user')"
        }
        format.html {
          flash[:error] = "You should not see this"
          render :action => "index"
        }
      end
    else
      respond_to do |format|
        format.js {
          render :text => "save failed"
        }
        format.html {
          flash[:error] = "Save failed"
          render :action => "index"
        }
      end
    end
  end

  def remote_handler
    #    first check for nickname
    @value = params["user"]["nickname"]
    if !@value.nil?
      @valid = User.find_by_nickname(@value).nil?
    else
      @value = params["user"]["email"]
      @valid = User.find_by_email(@value).nil?
    end
  end
  
  

end
