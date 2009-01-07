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

ActiveRecord::Schema.define(:version => 20090107185317) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_resources", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "resource_id"
  end

  add_index "categories_resources", ["category_id"], :name => "index_categories_resources_on_category_id"
  add_index "categories_resources", ["resource_id"], :name => "index_categories_resources_on_resource_id"

  create_table "diseases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiences", :force => true do |t|
    t.integer  "resource_id"
    t.string   "title"
    t.string   "would_recommend"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.integer  "user_id"
  end

  create_table "listings", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.binary   "status"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postalcode"
    t.decimal  "longitude",  :precision => 19, :scale => 15
    t.decimal  "latitude",   :precision => 19, :scale => 15
  end

  create_table "my_resources", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "disease_id"
    t.string   "how_affected"
    t.string   "affected_age"
    t.string   "affected_relationship"
    t.string   "location"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zipcode"
  end

  create_table "profiles_resources", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.integer  "listing_id"
    t.integer  "disease_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",       :precision => 10, :scale => 2
    t.string   "who_pays"
    t.string   "overview"
  end

  create_table "searches", :force => true do |t|
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
