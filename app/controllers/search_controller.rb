class SearchController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "application" }
  
  def index
    @disease = Disease.find(:all)
  end

  def step1
    @search = Search.new
    @search.disease_id = params[:id]
    @search.save

    redirect_to :action => "step2", :id => @search
  end

  def step2
    @search = Search.find(params[:id])
    @disease = Disease.find(@search.disease_id)
  end

  def step2_form
    @search = Search.find(params[:id])
    @search.how_affected = "Caregiver"
   
    if @search.update_attributes(params[:search])
      redirect_to :action => "step3",:id => @search
    else
      flash[:notice]='Something went wrong'
    end
  end

  def step2_link
    @search = Search.find(params[:id])
    @search.how_affected = params[:value]
    @search.save 
    redirect_to :action => "step3",:id => @search
  end

  def step3
    @search = Search.find(params[:id])
  end

  def step3_form
    @search = Search.find(params[:id])
    @search.location = params[:location][0]
    if @search.save then
      step4_path = url_for :controller => 'search', :action => 'step4', :id => @search
      if @search.location == 'United States'
        respond_to do |format|
          format.js {
            render :text => "step3_zip_show('#{step4_path}')"
          }
          format.html {
            flash[:error] = "US Selected HTML Run"
            render :action => "step3"}
        end
      else
        respond_to do |format|
          format.js {
            render :text => "redirect('#{step4_path}')"
          }
          format.html {
            redirect_to :action => "step4",:id => @search
          }
        end
         
      end
      
    else
      flash[:error]="Search coud not be saved"
      render :action => "step3"
    end
  end

  def step3_zip_form
    @search = Search.find(params[:id])
    if @search.update_attributes(params[:search])
      redirect_to :action => "step4",:id => @search
    else
      flash[:notice]='Something went wrong'
    end
  end

  def step4
    @search = Search.find(params[:id])
  end

  def join_hih
    @search = Search.find(params[:id])
    @user = User.new(params[:user])
    if @user.save
      @search.user = @user
      @search.save
      respond_to do |format|
        format.js {
          render :text => "saved"
        }
        format.html {
          flash[:error] = "You should not see this"
          render :action => "step4"
        }
      end
    else
      respond_to do |format|
        format.js {
          render :text => "save failed"
        }
        format.html {
          flash[:error] = "Save failed"
          render :action => "step4"
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
