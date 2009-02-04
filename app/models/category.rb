class Category < ActiveRecord::Base  
  has_and_belongs_to_many :resources,  :delete_sql => 'DELETE FROM categories_resources WHERE category_id = #{id}' 
end
