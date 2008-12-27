require 'net/http'

class MemFetcher
   def initialize
      # we initialize an empty hash
      @cache = {}
   end
   def fetch(url, max_age=0)
      # if the API URL exists as a key in cache, we just return it
      # we also make sure the data is fresh
      if @cache.has_key? url
         return @cache[url][1] if Time.now-@cache[url][0]<max_age
      end
      # if the URL does not exist in cache or the data is not fresh,
      #  we fetch again and store in cache
      @cache[url] = [Time.now, Net::HTTP.get_response(URI.parse(url)).body]
   end
end
