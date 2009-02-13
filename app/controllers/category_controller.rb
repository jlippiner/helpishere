class CategoryController < ApplicationController
  in_place_edit_for :category, :title

  def index
    @category = Category.find(:all)
    @new_category = Category.new
  end

  def new
    @category = Category.new
  end

  def save_remote
    @category = Category.new(params[:category])
    @category.title = @category.title.capitalize;
    if @category.save
      render :update do |page|
        page[:new_category].reset
        page.replace_html('dList', :partial => "category_list", :collection => Category.find(:all))
        page.visual_effect(:highlight, 'dList')
      end
    end if @category.save
  end

  def update_remote
    @category = Category.find(params[:id])
    @category.update_attribute("title", params[:text_string])
    render :text =>params[:text_string]
  end

  def destroy
    @category = Category.find(params[:id])
    @category.delete
    flash.now[:notice] = fading_flash_message(@category.title + " deleted.",5)
    redirect_to category_index_path
  end

end

