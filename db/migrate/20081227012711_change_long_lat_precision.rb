class ChangeLongLatPrecision < ActiveRecord::Migration
  def self.up
    change_column :listings, :longitude, :decimal, :precision => 19,  :scale => 15
    change_column :listings, :latitude, :decimal, :precision => 19,  :scale => 15
  end

  def self.down
  end
end
