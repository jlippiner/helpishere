class Disease < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :listings, :through => :resources, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  has_many :searches, :dependent => :destroy
  has_many :profiles, :dependent => :destroy
end
