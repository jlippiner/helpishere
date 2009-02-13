class ProfileController < ApplicationController
  def index
  end

  def new
    @profile = Profile.new_for(User.find(params[:id]))
  end

  def create
    @profile = Profile.create(params[:profile])
    if @profile.save
      session[:profile_id] = @profile.id
      flash.now[:notice] = "Profile Saved"
      redirect_to user_index_path
    else
      render  :action => "new"
    end
  end

  def destroy

    if (session[:profile_id].to_s.eql?(params[:id].to_s))
      session[:profile_id] = @current_profile = nil
    end

    @profile = Profile.find(params[:id])
    @profile.destroy

    # need to update current user since it has a deleted profile
    @current_user = User.find_by_id(session[:user_id])

    flash.now[:notice] = "Profile Deleted"
    redirect_to user_index_path
  end

  def edit
    @profile = Profile.find(params[:id])
    render :template => "profile/new"
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update_attributes(params[:profile])
      flash.now[:notice] = "Profile Updated"
      redirect_to user_index_path
    else      
      render :action => "edit", :template => "profile/new"
    end
  end

end
