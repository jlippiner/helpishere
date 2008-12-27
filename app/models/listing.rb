class Listing < ActiveRecord::Base
  has_many :resources
  has_many :diseases, :through => :resources
  belongs_to :user

  validates_uniqueness_of :title, :scope => [:address, :city, :state]
  
end
