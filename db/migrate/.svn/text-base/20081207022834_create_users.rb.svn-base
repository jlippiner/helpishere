class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.string :password
      t.string :zipcode
      t.binary :status

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
