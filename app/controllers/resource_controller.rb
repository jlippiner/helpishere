require 'net/http'
require 'rexml/document'
require 'lib/cache_fetcher'

class ResourceController < ApplicationController
  before_filter :login_required,  :profile_required
  
  def new
    case params[:step]
    when "2"
      h = {}
      params.each{ |k,v| h[k] = CGI::unescape(v) if Listing.column_names.include?(k)}
      h[:user_id]=@current_user.id
      
      @listing = Listing.find_by_title_and_address( h['title'], h['address'])
      @listing ||= Listing.create(h)
      
      render  :template => "resource/new_step_overview"
    when "3"
      @resource = Resource.new(params[:resource])
      @resource.user = @current_user
      @resource.listing_id = params[:id]
      @resource.disease = @current_profile.disease 
      @resource.save

      render  :template => "resource/new_step_experience"
    when "4"
      render  :template => "resource/new_step_categorize"
    else
      
    end
  end

  def remote_search
    @results = get_from_yahoo(params[:value])
    #    session[:add_resource_results] = @results

    sleep(1)
    
    render  :partial => "resource_list", :collection => @results
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
  end

  def index    
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
        value
      end
    end
  end


end
