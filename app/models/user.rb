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
    :url => "/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/Public/:class/:attachment/:id/:style_:basename.:extension",        
    :default_url => "/images/missing.gif",
    :whiny_thumbnails => true,
    :styles => {
    :thumb => "100x100#",
    :tiny => "50x50>",
    :medium => "75x75>"
  },
    :default_style => :thumb,
    :convert_options => {
    :thumb => "-border 5 -frame 3x3",
    :tiny => "-border 5 -frame 3x3"
    }

end
