require_dependency "lib/search"

class Listing < ActiveRecord::Base
  has_many :resources, :dependent => :destroy
  has_many :diseases, :through => :resources
  belongs_to :user
  searches_on :title, :address, :city, :state, :postalcode, :country

  validates_uniqueness_of :title, :scope => [:address, :city, :state]
  
end
