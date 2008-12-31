class FixCommentAddUser < ActiveRecord::Migration
  def self.up
    remove_column :experiences, :comments
    add_column :experiences, :comment, :string
    add_column :experiences, :user_id, :integer
  end

  def self.down
    remove_column :experiences, :comment
    remove_column :experiences, :user_id
  end
end
