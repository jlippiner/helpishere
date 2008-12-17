class DefaultStatusForUser < ActiveRecord::Migration
  def self.up
    change_column :users, :status, :integer, { :default => 1 }
  end

  def self.down
  end
end
