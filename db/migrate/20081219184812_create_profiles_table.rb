class CreateProfilesTable < ActiveRecord::Migration
  def self.up
    drop_table :profiles

    remove_column :searches, :user_id

    create_table :profiles do |t|
      t.integer :user_id
      t.integer :disease_id
      t.string :how_affected
      t.string :affected_age
      t.string :affected_relationship
      t.string :location
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table profiles
  end
end
