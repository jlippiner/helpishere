class DropCommentFromResources < ActiveRecord::Migration
  def self.up
    remove_column :resources, :comment
  end

  def self.down
  end
end
