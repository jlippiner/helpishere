class Profile < ActiveRecord::Base
  belongs_to :disease
  belongs_to :user

  def self.create_from_search(search, profile_name)
    self.affected_age = search.affected_age
    self.affected_relationship = search.affected_relationship
    self.disease_id = search.disease_id
    self.how_affected = search.how_affected
    self.location = search.location
    self.name = profile_name    
  end
  
end
