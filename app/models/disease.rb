class Disease < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :listings, :through => :resources
  has_many :resources
  has_many :searches
  has_many :profiles
end
