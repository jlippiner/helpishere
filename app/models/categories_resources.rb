class CategoriesResources < ActiveRecord::Base
  def self.distinct
    self.category_id.uniq
  end
end
