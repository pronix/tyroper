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

ActiveRecord::Schema.define(:version => 9) do

  create_table "cities", :force => true do |t|
    t.text "name", :null => false
  end

  create_table "countries", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foodtypes", :force => true do |t|
    t.text "name",        :null => false
    t.text "description"
  end

  create_table "hotels", :force => true do |t|
    t.text "name",        :null => false
    t.text "description"
  end

  create_table "roomtypes", :force => true do |t|
    t.text "name",        :null => false
    t.text "description"
  end

  create_table "tourists", :force => true do |t|
    t.text     "name_kir"
    t.text     "ot4_kir"
    t.text     "surname_kir"
    t.boolean  "sex"
    t.text     "name_lat"
    t.text     "surname_lat"
    t.date     "borndate"
    t.text     "reklama"
    t.text     "pasport_ros"
    t.integer  "seriya_zag_pasp"
    t.integer  "nomer_zag_pasp"
    t.text     "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "travelpoints", :force => true do |t|
    t.integer  "city_id"
    t.integer  "country_id",  :null => false
    t.integer  "hotel_id",    :null => false
    t.integer  "roomtype_id"
    t.integer  "foodtype_id"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "travels", :force => true do |t|
    t.binary   "platezhka"
    t.binary   "podtver"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
