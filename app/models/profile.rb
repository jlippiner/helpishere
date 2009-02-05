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


 def self.new_for(user)
   self.new(:user => user)
 end
end
