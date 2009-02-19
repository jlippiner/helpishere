class Profile < ActiveRecord::Base
  belongs_to :disease
  belongs_to :user
  has_many :my_resources
  has_many :resources, :through => :my_resources do
    def for_categories(ids, options = {})
      find(:all, options.merge(:conditions => ["categories.id IN (?)", ids], :include => [:categories]))
    end

     def for_categories_and_starts_with(ids, letter, options = {})
      find(:all, options.merge(:conditions => ["categories.id IN (?) AND listings.title LIKE (?)", ids,letter + '%'], :include => [:categories,:listing]))
    end

     def for_categories_and_listing_contains(ids, query, options = {})
       query = '%' + query.upcase + '%'
       find(:all, options.merge(:conditions => ["categories.id IN (:cat_ids) AND (UCASE(listings.title) LIKE (:query) OR UCASE(listings.address) LIKE (:query) OR UCASE(listings.city) LIKE (:query) OR UCASE(listings.postalcode) LIKE (:query))", {:cat_ids => ids, :query => query}], :include => [:categories,:listing]))
    end
  end

  validates_presence_of :disease_id, :location, :how_affected
  validates_presence_of :name, :message => "is blank.  Please select a disease and how you are affected."

 def create_from_search(search, user, profile_name)
    self.affected_age = search.affected_age
    self.affected_relationship = search.affected_relationship
    self.disease_id = search.disease_id
    self.how_affected = search.how_affected
    self.location = search.location
    self.name = profile_name
    self.user_id = user.id
  end

  # Return yahoo results that are unknown to the current profile
  def unkown_yahoo_results(yahoo_results)
    resources = self.resources
    disease_resources = disease.resources
    
    @results = yahoo_results.inject([]) do |results,r|
      resource = disease_resources.detect do |t|
        (t.listing.address == r.address && t.listing.title == r.title && t.listing.city ==  r.city)
      end

      results ||= []
      if (resource.blank:query)  # Need this to include records found that are NOT in the database at all
        results << {:resource_id => 0, :data => r }
      elsif (!resource.blank:query && !resources.detect { |t| resource.id == t.id })
        results << {:resource_id => resource.id, :data => r }
      end
    end
  end


 def self.new_for(user)
   self.new(:user => user)
 end
end
