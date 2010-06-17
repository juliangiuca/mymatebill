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

ActiveRecord::Schema.define(:version => 20091211224543) do

  create_table "accounts", :force => true do |t|
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
    t.string   "password_reset_code",       :limit => 40
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login"

  create_table "associations", :id => false, :force => true do |t|
    t.integer  "identity_id"
    t.integer  "associate_id"
    t.string   "nickname"
    t.datetime "deleted_at"
  end

  create_table "identities", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.float    "cash_in",           :default => 0.0
    t.float    "cash_out",          :default => 0.0
    t.float    "cash_pending",      :default => 0.0
    t.float    "total"
    t.date     "befriended_on"
    t.string   "unique_magic_hash"
    t.string   "email"
    t.datetime "deleted_at"
  end

  add_index "identities", ["account_id"], :name => "index_identities_on_account_id"
  add_index "identities", ["unique_magic_hash"], :name => "index_identities_on_unique_magic_hash"

  create_table "transactions", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "from_associate_id"
    t.integer  "to_associate_id"
    t.integer  "owner_id"
    t.string   "description"
    t.date     "due"
    t.float    "amount"
    t.string   "state"
    t.string   "unique_magic_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["unique_magic_hash"], :name => "index_transactions_on_unique_magic_hash"

end
