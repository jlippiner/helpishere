# Yahoo::Local - Ruby Library to interface with Yahoo Local Api x2
# Copyright 2007 Eric Allam <ericallam@gmail.com>.
# 
# Yahoo::Local is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# Yahoo::Local is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Yahoo::Local; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

require 'rubygems'
require 'net/http'
require 'rexml/document'
require 'cgi'
require File.dirname(__FILE__)  + '/extensions'

  # Library for searching Yahoo Local
  # 
  # How to use:
  #
  # Set Yahoo application id on the Local Module:
  #
  # Local.app_id = 'yourapikeygoeshere'
  #
module Local
  
  mattr_accessor :app_id
  
  # The +search+ method takes two parameters
  # Local.search(query, options)
  #
  # example: Local.search("pizza" , {:zip => 32304, :results => 10, :sort => :relevance})
  #
  # query is a string (what your searching for (eg: 'pizza'))
  #
  # more options:
  # * :results - integer (default: 10, max: 20) - the number of results to return
  # * :start - integer (default: 1) - the starting result position to return 
  # * :sort - string ('relevance' default , 'title' , 'distance', 'rating') - sorts the results by the chosen criteria
  # * :radius - float - How far (in miles) from the specified location to search for the query terms. The default radius varies according to the location given.
  # * :street - string - street name.  the number is optional
  # * :city - string - City name.
  # * :state - string - The United States state.  You can spell out the full state name or you can use the two-letter abbreviation
  # * :zip - integer or <integer>-<integer> - The five-digit zip code, or the five-digit code plus four-digit extension. If this location contradicts the city and state specified, the zip code will be used for determining the location and the city and state will be ignored.
  # * :location - string -  This free field lets users enter any of the following:
  # 
  #     * city, state
  #     * city, state, zip
  #     * zip
  #     * street, city, state
  #     * street, city, state, zip
  #     * street, zip
  # 
  # If location is specified, it will take priority over the individual fields in determining the location for the query. City, state and zip   will be ignored.
  # * :latitude - float: -90 to 90  - The latitude of the starting location.
  # * :longitude -  float: -180 to 180  - The longitude of the starting location. If both latitude and longitude are specified, they will take priority over all other location data. If only one of latitude or longitude is specified, both will be ignored.
  #
  # Returns a Response object
  #
  # response = Local.search('pizza', {:zip => 32304})
  # 
  # response.results will return an array of +Result+ objects
  # 
  # eg:
  # response.results.each {|result| puts result.title }
  #
  # > Hungry Howies
  #
  # > Pizza Hut
  #
  # > Dominoes
  
  def self.search(query, options)
    Request.new(options).fetch(query).results
  end

# encapsulates a request to Yahoo LocalR
#
# has one class accessor:
# +options+ - see +search+ for details about accepted options
class Request
  attr_accessor :options
  
  def initialize(options = {})
    @options = options.reverse_merge! :results => 10, :start => 1, :sort => :relevance, :output => :xml
  end
  
  # performs the request and returns a +Response+ object
  #
  # Request.new(options).fetch(query)
  def fetch(query)
    Response.new get(url(query))
  end
  
  def path(query)
      string  =   "http://local.yahooapis.com/LocalSearchService/V2/localSearch?"
      string  +=  "appid=#{Local.app_id}&query=#{CGI::escape(query)}"
      @options.each do |key, value|
        string += "&#{key.to_s}=#{CGI::escape(value.to_s)}"
      end
      string
  end
  
  private
  
  def get(url)
    Net::HTTP::get(url)
  end
  
  def url(query)
    URI::parse(path(query))
  end
  
end

# encapsulates the response from yahoo
#
# has one attr_reader:
#
# +body+  a REXML::Element containing the ResultSet returned by the request
class Response 
  attr_reader :body
  
  def initialize(xml)
     @body = REXML::Document.new(xml).root
     @results = Array.new
  end
  
  # returns true if request was a success and no errors were returned
  def success?
    !failure?
  end
  
  # returns false if errors returns  
  def failure?
    !error.nil?
  end
    
  def error # :nodoc:
    @body.elements['//Error']
  end
  

  # The number of query matches in the database.  
  def total_results
    @body.root.attributes["totalResultsAvailable"].to_i
  end
  
  # The number of query matches returned. This may be lower than the number of results requested if there were fewer total results available.
  def total_returned
    @body.root.attributes["totalResultsReturned"].to_i
  end
  
  # The position of the first result in the overall search.
  def first_position
    @body.root.attributes["firstResultPosition"].to_i
  end
  
  # returns an array of +Result+ objects
  # 
  # a +Result+ is one establishment returned by your search
  def results
    results = [] 
      @body.elements.each("Result") do |result|
        results << Result.new(result)
      end
    results
  end
  
end

# A location/joint/business/pizza place returned from Yahoo
#
# Attributes:
# * +title+ - Name of the Result
# * +address+ - Street address of the result
# * +city+ - city in which the result is located
# * +state+ - Hmm...possibly the state where the result is located
# * +phone+ - push these numbers sequentually into phone device to talk directly with result
# * +latitude+ - lat of location
# * +longitude+ - see above but replace 'lat' with 'long' (thats what she said)
# * +rating+ - a +Rating+ object
# * +distance+ -  The distance as calculated by one of the following methods:
    # 
    # * When you enter a street address along with your search term, this is the distance from that particular street address to each result.
    # * When you enter your search term along with a city or a city and state, this is the distance from the city center to the business you're looking for.
# * +url+ - the URL to the detailed page for a business
# * +clickurl+ - The URL for linking to the detailed page for a business. See URL linking for more information.
# * +mapurl+ - The URL of a map for the address.
# * +businessurl+ - The URL of the business website, if known
# * +businessclickurl+ - The URL for linking to the businesses website if known. See URL linking for more information.

class Result
  attr_reader :result, :ratings
  
  def initialize(result)
    @result = result
    construct_methods
    @ratings = Rating.new(result)
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

# Rating information for a +Result+
#
# * +average+ - The average rating for the result
# * +total+ - Total number of ratings for the result
# * +reviews+ - Total number of reviews for the result

class Rating
  attr_reader :average, :total, :reviews
  
  def initialize(result) # :nodoc:
    @average = parse(result, "AverageRating")
    @total = parse(result, "TotalRatings")
    @reviews = parse(result, "TotalReviews")
  end
  
  def parse(result, name) # :nodoc:
    result.elements["//Rating/#{name}"].get_text.to_s.to_i rescue 0
  end
  
end









end