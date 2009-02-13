require 'net/http'
require 'rexml/document'
require 'lib/cache_fetcher'

class ResourceController < ApplicationController
  before_filter :login_required,  :profile_required
  before_filter :create_map
  
  
  def new
    @categories = Category.find(:all, :order=>'title')   
  end

  def create
  end

  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    flash.now[:notice] = "Resource Deleted"
    redirect_to user_index_path
  end


  def index
    uniq_cats
    @ids = @cats.map { |c| c.id.to_s  }    # @ids used to persist checkbox selection

    session[:group] = params[:group]
    if(!params[:letter].nil?)
      group_resources_alphabetically(params[:letter])
    else
      group_resources    
    end
    
        
    session[:ids] = @ids
  end

  def filter
    @ids = params[:category_ids]

    if(!@ids.nil?)
      session[:ids] = @ids
    else
      @ids = session[:ids]
    end

    uniq_cats
    group_resources
    
    render :template => "resource/index"
  end

  def edit
    @resource = Resource.find(params[:id])
    @listing = @resource.listing
    @categories = Category.find(:all, :order=>'title')

    @section = params[:section]
  end

  def update_listing
    if params[:commit]=='Cancel'
      redirect_to resource_index_path
      return false
    end
    
    @resource = Resource.find(params[:id])
    @listing = @resource.listing
    if @listing.update_attributes(params[:listing])
      flash.now[:notice] = @listing.title + " Updated!"
      redirect_to resource_index_path
    else
      flash[:error] = "Something went wrong"
      redirect_to resource_edit_path(params[:id])
    end
  end

  def update_details
    if params[:commit]=='Cancel'
      redirect_to resource_index_path
      return false
    end

    @resource = Resource.find(params[:id])
    if @resource.update_attributes(params[:resource])
      flash.now[:notice] = @resource.listing.title + " Details Updated!"
      redirect_to resource_index_path
    else
      flash[:error] = "Something went wrong"
      redirect_to resource_edit_path(params[:id])
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

  def overview
    @resource = Resource.find(params[:id])
    @method = params[:method]
    
    if @method=='update'
      if @resource.update_attributes(params[:resource])
        flash.now[:notice] = @resource.listing.title + " Overview Updated!"
        redirect_to resource_index_path
      else
        flash[:error] = "Something went wrong"
        redirect_to resource_edit_path(params[:id])
      end
    end
  end


  def remote_search
    yahoo_results = get_from_yahoo(params[:value])# (title, address, city, state, zip, country, phone)
    @results = @current_profile.unkown_yahoo_results(yahoo_results)

    sleep(1)
    render  :partial => "resource_list", :collection => @results
  end

  def remote_search_bak
    yahoo_results = get_from_yahoo(params[:value])

    #    check existing resources and remove if found
    titles =@current_profile.resources.map{|r| r.listing.title + r.listing.address + r.listing.city }.flatten
    all_titles = @current_profile.disease.resources.map{|r| {:id => r.id, :title => r.listing.title, :address => r.listing.address, :city => r.listing.city  } }.flatten

    @results = []
    yahoo_results.each do |r|
      unless(titles.include?(r.title + r.address + r.city))
        resource_id = 0
        all_titles.each do |a|
          if([a[:title] + a[:address] + a[:city]].include?(r.title + r.address + r.city))
            resource_id = a[:id]
            break
          end
        end 
        @results << {:resource_id => resource_id, :data => r }
      end
    end

    sleep(1)

    render  :partial => "resource_list", :collection => @results
  end

  def remote_add
    unless(params[:id])
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

    else
      resource = Resource.find(params[:id])
    end

    # Add profile to resource
    if !@current_profile.resources.include?(resource)
      @current_profile.resources << resource
    end

    #    render :partial => "resource_basket_json", :collection => @current_profile.resources.find(:all, :order => "created_at DESC")    
    out = {:resource => resource.attributes, :listing => resource.listing.attributes}
    render :text => out.to_json()
  end

  def remote_reload_basket
    render :partial => "resource_basket", :collection => @current_profile.resources.find(:all, :order => "created_at DESC")
  end

  def remote_experience
    resource = Resource.find(params[:experience][:resource_id])
    if Experience.create(params[:experience])
      render :text => resource.listing.title + ' added to this profile.'
    end
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


  private
  def uniq_cats
    @cats =@current_profile.resources.map{|r| r.categories }.flatten.uniq.sort_by {|c| c.title}
  end

  def group_resources
    if(session[:group]=='alpha')
      group_resources_alphabetically
    else
      group_resources_by_category
    end
  end


  def group_resources_alphabetically(a_letter = nil)
    #    group into buckets
    @groups = []
    @letters = []
    ('A'..'Z').each do |c|
      group = {:title => c, :data =>  @current_profile.resources.for_categories_and_starts_with(@ids,c)}
      if !group[:data].empty?
        @groups << group if(a_letter.nil? || a_letter==c)

        @letters << c
      end
    end
  end

  def group_resources_by_category(options = {})
    #    group into buckets
    @groups = []
    @cats.each do |c|
      if (@ids.include?(c.id.to_s))
        o = {:conditions => ["profile_id = ?",@current_profile], :include => [:profiles,:listing], :order => "title"}.merge(options)
        group = {:title => c.title, :data => c.resources.find(:all,o)}
        @groups << group
      end
    end
  end

  def create_map
    if @current_profile
      if (@current_profile.resources.count > 0)
        #     deal with maps
        @map = GMap.new("map_div")
        @map.control_init(:small_map => true, :map_type => false)
        @map.center_zoom_init([@current_profile.resources.first.listing.latitude,@current_profile.resources.first.listing.longitude],10)

        markers = []
        @current_profile.resources.each do |t|
          markers << GMarker.new([t.listing.latitude,t.listing.longitude],:title => t.listing.title,:info_window => t.listing.title + "<br>" + t.listing.address)
        end

        managed_markers = ManagedMarker.new(markers,0,12)

        mm = GMarkerManager.new(@map,:managed_markers => [managed_markers])
        @map.declare_init(mm,"mgr")

      end
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
