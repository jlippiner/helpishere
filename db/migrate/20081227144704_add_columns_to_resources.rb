class AddColumnsToResources < ActiveRecord::Migration
  def self.up
#    #    remove first from listings
    remove_column :listings, :who_pays
    remove_column  :listings, :services_rendered
    remove_column :listings, :cost

    #    add columns to resources
    add_column  :resources, :cost, :decimal, :precision => 10, :scale => 2
    add_column  :resources, :who_pays, :string
    add_column  :resources, :overview, :string
  end

  def self.down
    remove_column :resources, :cost
    remove_column :resources, :who_pays
    remove_column :resources, :overview
  end
end
