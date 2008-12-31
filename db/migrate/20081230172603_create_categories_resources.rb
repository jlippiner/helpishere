class CreateCategoriesResources < ActiveRecord::Migration
  def self.up
    create_table :categories_resources, :id => false do |t|
      t.integer :category_id
      t.integer :resource_id
    end
    add_index :categories_resources, :category_id
    add_index :categories_resources, :resource_id

  end

  def self.down
    drop_table :categories_resources
  end
end
