# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081216224059) do

  create_table "diseases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", :force => true do |t|
    t.string   "title"
    t.string   "who_pays"
    t.text     "services_rendered"
    t.integer  "user_id"
    t.integer  "cost",              :limit => 10, :precision => 10, :scale => 0
    t.binary   "status"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
  end

  create_table "resources", :force => true do |t|
    t.integer  "listing_id"
    t.integer  "disease_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "disease_id"
    t.string   "how_affected"
    t.string   "affected_age"
    t.string   "affected_relationship"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zipcode"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "password"
    t.string   "zipcode"
    t.integer  "status",     :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
