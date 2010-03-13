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

ActiveRecord::Schema.define(:version => 20091211225425) do

  create_table "accounts", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "actors", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
  end

  create_table "events", :force => true do |t|
    t.string  "description"
    t.integer "account_id"
    t.date    "occured_on"
    t.integer "actor_id"
    t.float   "amount"
  end

  create_table "friends", :force => true do |t|
    t.integer "owner_id"
    t.integer "user_id"
    t.string  "name"
    t.float   "money_in",          :default => 0.0
    t.float   "money_out",         :default => 0.0
    t.float   "total"
    t.date    "befriended_on"
    t.string  "unique_magic_hash"
    t.string  "email_address"
  end

  add_index "friends", ["unique_magic_hash"], :name => "index_friends_on_unique_magic_hash"
  add_index "friends", ["user_id"], :name => "index_friends_on_user_id"

  create_table "line_items", :force => true do |t|
    t.integer "event_id"
    t.integer "friend_id"
    t.float   "amount"
    t.date    "paid_on"
    t.boolean "confirmed_payment"
    t.date    "confirmed_on"
    t.string  "state"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
