require 'net/http'
require 'rexml/document'
require 'lib/cache_fetcher'

class ResourceController < ApplicationController
  before_filter :login_required,  :profile_required
  
  def new
    @categories = Category.find(:all, :order=>'title')   
  end

  def remote_search
    @results = get_from_yahoo(params[:value])
    #    session[:add_resource_results] = @results

    sleep(1)
    
    render  :partial => "resource_list", :collection => @results
  end

  def remote_add
    parts = params[:listing].split(/&|=/)
    l = Hash[*parts]

    h = {}
    l.each{ |k,v| h[k] = CGI::unescape(v) if Listing.column_names.include?(k)}
    h[:user_id]=@current_user.id

    # listing does not exist so create and add resource    
    listing = Listing.find_by_title_and_address(h['title'],h['address'])
    listing ||= Listing.create(h)

    # Exists so check on resource for this disease
    resource = Resource.find_by_disease_id_and_listing_id(@current_profile.disease.id,listing.id)

    if !resource
      # does not exist so create resource
      resource = Resource.new() do |r|
        r.user = @current_user
        r.listing = listing
        r.disease = @current_profile.disease        
      end

      resource.update_attributes(params[:resource])
    end
          
    # Add profile to resource
    if !@current_profile.resources.include?(resource)
      @current_profile.resources << resource
    end

    render  :partial => "resource_basket", :collection => @current_profile.resources.find(:all, :order => "created_at DESC")
  end

  def remote_delete
    resource = Resource.find(params[:id])
    if resource
      @current_profile.resources.delete(resource)
    end

    render  :partial => "resource_basket", :collection => @current_profile.resources
  end

  def get_from_yahoo(query)
    if (!query.include?(','))
      return if @current_profile.zipcode.nil?
      @options = {:zip => @current_profile.zipcode, :results => "10"}
    else
      #    comma included so check on location?
      parts = query.split(',',2)
      query = parts[0]
      location = parts[1]
      @options = {:location => location, :results => "10"}
    end

    string  =   "http://local.yahooapis.com/LocalSearchService/V3/localSearch?"
    string  +=  "appid=#{YAHOO_API_KEY}&query=#{CGI::escape(query)}"
    @options.each do |key, value|
      string += "&#{key.to_s}=#{CGI::escape(value.to_s)}"
    end

    begin
      fetcher = MemFetcher.new
      data = fetcher.fetch(string,60)
    rescue
      print "Connection error."
    end

    # extract event information
    doc = REXML::Document.new(data[1])

    # a +Result+ is one establishment returned by your search
    results = []
    doc.elements.each('ResultSet/Result') do |result|
      results << Result.new(result)
    end
    
    results
  end

  def create
  end

  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    flash[:notice] = "Resource Deleted"
    redirect_to user_index_path
  end

  def index
    @list = @current_profile.resources.sort_by { |m| m.listing.title}
    @cats = @current_profile.resources.distinct_categories
  end

  def filter      
      @ids = params[:category_ids]
      @list = @current_profile.resources.select{|r| @ids.include? r.categories.id }
      @r = Resource.new
      render :template => "resource/index"
  end

  def remote
    case params[:do]
    when "sort_name"
      @list = @current_profile.resources.sort_by { |m| m.listing.title}
      render :partial => "myresources_list", :collection => @list
    when "sort_city"
      @list = @current_profile.resources.sort_by { |m| m.listing.city}
      render :partial => "myresources_list", :collection => @list
    when "filter_cats"

    else
    end
  end

  def summary
    @resource = Resource.find(params[:id])
    if @resource
      @map = GMap.new("map_div")
      @map.control_init(:small_map => true)
      @map.center_zoom_init([@resource.listing.latitude,@resource.listing.longitude],8)
      @map.overlay_init(GMarker.new([@resource.listing.latitude,@resource.listing.longitude],:title => @resource.listing.title, :info_window => @resource.listing.title))
    end
  end

end

class Result
  attr_reader :result

  def initialize(result)
    @result = result
    construct_methods
  end

  def construct_methods # :nodoc:
    @result.elements.each do |element|
      define_attr_method(element.name.downcase, element.get_text.to_s)
    end
  end

  def define_attr_method(name, value) # :nodoc:
    singleton_class.class_eval do
      define_method(name) do
        if value!=''
          value
        else
          ' '
        end
      end
    end
  end


end
