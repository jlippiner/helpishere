class Resource < ActiveRecord::Base
  belongs_to :disease
  belongs_to :listing 
  belongs_to :user
  has_many :experiences, :dependent => :destroy
  has_and_belongs_to_many :categories, :delete_sql => 'DELETE FROM categories_resources WHERE resource_id = #{id}' 

  
  has_many :profiles, :through => :my_resources
  has_many :my_resources

  validates_uniqueness_of :listing_id, :scope => [:user_id, :disease_id]
  
end
