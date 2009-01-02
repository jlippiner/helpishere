require 'lib/cache_fetcher'

class HomepageController < ApplicationController
  def index
    words = ["caring", "love", "support", "help", "smile", "holding hands"]
    term = words[rand(words.size)]

    flickr = Flickr.new

    @photos = Rails.cache.fetch('photo_' + term, :expires_in => 15.minutes ) {
      flickr.photos(:tags => term, :per_page => '9')
    }
    
  end

end
