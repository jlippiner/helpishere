class AddBioToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :bio, :string
  end

  def self.down
    remove_colume :users, :bio
  end
end
