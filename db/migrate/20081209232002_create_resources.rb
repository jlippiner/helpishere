class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :listing_id
      t.integer :disease_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
