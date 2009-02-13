class DiseasesController < ApplicationController
  in_place_edit_for :disease, :name

  def welcome
    session[:return_to] = request.path
  end

  def index
    @disease = Disease.find(:all)
    @new_disease = Disease.new
  end

  def new
    @disease = Disease.new
  end

  def save_remote
    @disease = Disease.new(params[:disease])
    if @disease.save
      render :update do |page|
        page[:new_disease].reset
        page.replace_html('dList', :partial => "disease_list", :collection => Disease.find(:all))
        page.visual_effect(:highlight, 'dList')        
      end
    end if @disease.save
  end

  def destroy
    @disease = Disease.find(params[:id])
    @disease.delete
    flash.now[:notice] = fading_flash_message(@disease.name + " deleted (what a nice concept)",5)
    redirect_to diseases_path
  end

end
