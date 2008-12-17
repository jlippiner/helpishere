class AddWebsiteToResources < ActiveRecord::Migration
  def self.up
    add_column  :listings, :website, :string
  end

  def self.down
    remove_column :listings, website
  end
end
