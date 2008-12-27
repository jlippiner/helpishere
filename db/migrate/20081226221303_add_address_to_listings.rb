class AddAddressToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :address, :string
    add_column :listings, :city, :string
    add_column :listings, :state, :string
    add_column :listings, :country, :string
    add_column :listings, :postalcode, :string
    add_column :listings, :longitude, :decimal
    add_column :listings, :latitude, :decimal
  end

  def self.down
    remove_column :listings, :address
    remove_column :listings, :city
    remove_column :listings, :state
    remove_column :listings, :country
    remove_column :listings, :postalcode
    remove_column :listings, :longitude
    remove_column :listings, :latitude
  end
end
