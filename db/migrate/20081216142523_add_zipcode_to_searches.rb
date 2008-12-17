class AddZipcodeToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :zipcode, :string
  end

  def self.down
    remove_column :searches, :zipcode
  end
end
