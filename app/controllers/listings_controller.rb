class ListingsController < ApplicationController
  layout "admin"
  active_scaffold

#  def index
#    @listings = Listing.find(:all)
#  end
#
#  def new
#    @listing = Listing.new
#    Disease.find(:all).each do |d|
#      @listing.resources.build(:disease => d)
#    end
#  end
#
#  def edit
#  end
#
#  def create
#    @listing = Listing.new(params[:listing])
#
#    params[:resources].each_value do |k|
#      @listing.resources.new(k)
#    end
#    if @customer.save
#      redirect_to :action => 'index'
#    else
#      render :action => 'new'
#    end
#
#  end

end
