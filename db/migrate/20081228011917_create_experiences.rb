class CreateExperiences < ActiveRecord::Migration
  def self.up
    create_table :experiences do |t|
      t.integer :resource_id
      t.string :title
      t.string :comments
      t.string :would_recommend

      t.timestamps
    end
  end

  def self.down
    drop_table :experiences
  end
end
