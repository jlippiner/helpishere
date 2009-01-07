class CreateMyResources < ActiveRecord::Migration
  def self.up
    create_table :my_resources do |t|
      t.integer :resource_id
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_resources
  end
end
