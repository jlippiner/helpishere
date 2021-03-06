class UserController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "application" }
  before_filter :login_required, :only => [:index, :logout, :welcome, :edit, :update]
  before_filter :create_map
     
  def logout
    session[:user_id] = @current_user = nil
    session[:profile_id] = @current_profile = nil
    flash.now[:notice]="You are now logged out."
    render :action => "login"
  end

  def create_map
    if @current_user      
      if (@current_user.resources.count > 0)
        #     deal with maps
        @map = GMap.new("map_div")
        @map.control_init(:small_map => true)
        @map.center_zoom_init([@current_user.resources.first.listing.latitude,@current_user.resources.first.listing.longitude],7)

        markers = []
        @current_user.resources.each do |t|
          markers << GMarker.new([t.listing.latitude,t.listing.longitude],:title => t.listing.title,:info_window => t.listing.title + "<br>" + t.listing.address)
        end

        managed_markers = ManagedMarker.new(markers,0,7)

        mm = GMarkerManager.new(@map,:managed_markers => [managed_markers])
        @map.declare_init(mm,"mgr")

      end
    end
  end

  def index
    
  end

  def welcome
    if !@current_profile.nil?
      render :action => "index"
    end
  end
  
  def login
    return if params[:login].to_s.nilemp? or params[:password].to_s.nilemp?
    
    @current_user = User.find_by_email_and_password(params[:login], params[:password])

    if @current_user
      session[:user_id]=@current_user.id
      url = user_index_path
      url = session[:return_to] if !session[:return_to].nil?
      redirect_to url
    else
      flash.warning = "Invalid email or password.  Please try again"
      render :action => "login"
    end
  end

  def join
    @user = User.new(params[:user])
    if @user.save
      if session[:search_id]
        @search = Search.find(session[:search_id])
        @profile = Profile.new
        @profile.create_from_search(@search, @user, @search.disease.name + ' - ' + @search.how_affected)
        @profile.save
        session[:profile_id]=@profile.id
      end
      
      @current_user = @user
      session[:user_id]=@current_user.id

      respond_to do |format|
        format.js {
          render :text => "redirect('#{user_welcome_path}')"
        }
        format.html {
          flash[:error] = "You should not see this"
          render :action => "index", :template => "welcome"
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

  def remote
    ret = false
    case params[:do]
    when "nickname"
      val = params["user"]["nickname"]
        ret = User.find_by_nickname(val).nil? unless val.blank?
    when "email"
      val = params["user"]["email"]
      if(@current_user)
        ret = @current_user.email = val #        need to do this to allow people updating their info to use same email address
      else
        ret = User.find_by_email(val).nil?
      end
    end
    render :text => ret
  end
  
  def change_profile
    @current_profile = Profile.find(params[:id])
    render :partial => "profiles", :collection => @current_user.profiles
  end

  def get_current_profile
    @current_profile = Profile.find(params[:id])
    session[:profile_id] = params[:id]
    render :text => "Current Profile: <a href='#{url_for user_index_path}'>#{@current_profile.name}</a>"
  end

  def update
    @user = User.find(@current_user.id)
    if @user.update_attributes(params[:user])
      @current_user = @user
      flash.now[:notice] = "Your information has been updated.  Have a wonderful day."
    end

    render :action => "index"
  end

  def update_picture
    @user = User.find(@current_user.id)
    if @user.update_attributes(params[:user])
      @current_user = @user
      flash.now[:notice] = "Picture updated!  That's pretty."
    else
      out = "ERROR: "
      @user.errors.each do |e|
        out = out + e.join("<br>")
      end
      flash[:error] = out
    end
    render :action => params[:next]
  end

end
