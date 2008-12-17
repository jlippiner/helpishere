class CreateSearchTable < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :user_id
      t.integer :disease_id
      t.string :how_affected
      t.string :affected_age
      t.string :affected_relationship
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
