class User < ActiveRecord::Base
  has_many :listings
  has_many :listings, :through => :resources
  has_many :resources
  has_many :searches, :dependent => :destroy
  has_many :profiles, :dependent => :destroy
  has_many :experiences, :dependent => :destroy

  validates_presence_of :name, :nickname, :email, :password
  validates_uniqueness_of :nickname, :email

  # Paperclip
  has_attached_file :photo,
    :styles => {
    :thumb => "100x100>",
    :small => "150x150>",
    :medium => ["300x300>", :gif]
  }, :url => "/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/Public/:class/:attachment/:id/:style_:basename.:extension",        
    :default_url => "/images/missing.gif",
    :whiny_thumbnails => true

end
