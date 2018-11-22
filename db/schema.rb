# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_21_150736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uid", null: false
    t.date "processed_on", null: false
    t.string "iso_currency_code"
    t.string "name"
    t.decimal "deposit", precision: 15, scale: 10, default: "0.0", null: false
    t.decimal "credit", precision: 15, scale: 10, default: "0.0", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id", "uid"], name: "index_account_transactions_on_account_id_and_uid", unique: true
    t.index ["account_id"], name: "index_account_transactions_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "plaid_token"
    t.string "uid"
    t.string "dwolla_token"
    t.string "type"
    t.decimal "balance", precision: 15, scale: 10, default: "0.0", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "institution"
    t.string "account_type"
    t.string "iso_currency_code"
    t.text "plaid_identity"
    t.string "institution_id"
    t.string "mask"
    t.index ["plaid_token", "uid", "dwolla_token"], name: "index_accounts_on_plaid_token_and_uid_and_dwolla_token", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.string "uid"
    t.string "type"
    t.string "link"
    t.string "status", default: "unverified", null: false
    t.string "customer_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["profile_id", "uid"], name: "index_customers_on_profile_id_and_uid", unique: true
    t.index ["profile_id"], name: "index_customers_on_profile_id"
  end

  create_table "funding_sources", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "account_id", null: false
    t.string "link"
    t.string "uid"
    t.string "status", default: "pending", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id", "uid"], name: "index_funding_sources_on_account_id_and_uid", unique: true
    t.index ["account_id"], name: "index_funding_sources_on_account_id"
    t.index ["customer_id"], name: "index_funding_sources_on_customer_id"
  end

  create_table "invest_sets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "source_account_id", null: false
    t.bigint "invest_account_id", null: false
    t.string "frequency", default: "daily", null: false
    t.integer "lowest"
    t.decimal "amount", precision: 15, scale: 10, default: "0.0", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "rel_min_balance", precision: 15, scale: 10, default: "5.0", null: false
    t.string "status", default: "active", null: false
    t.datetime "cancelled_at"
    t.index ["invest_account_id"], name: "index_invest_sets_on_invest_account_id"
    t.index ["source_account_id"], name: "index_invest_sets_on_source_account_id"
    t.index ["user_id"], name: "index_invest_sets_on_user_id"
  end

  create_table "invest_transactions", force: :cascade do |t|
    t.bigint "invest_set_id", null: false
    t.string "status", default: "planned", null: false
    t.decimal "amount", precision: 15, scale: 10, default: "0.0", null: false
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "iso_currency_code"
    t.datetime "cancelled_at"
    t.string "uid"
    t.string "investment_type"
    t.string "link"
    t.index ["invest_set_id"], name: "index_invest_transactions_on_invest_set_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document"
    t.string "encrypted_dob"
    t.string "encrypted_ssn"
    t.string "encrypted_dob_iv"
    t.string "encrypted_ssn_iv"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "role", default: "user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "admin_set_by_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "customers", "profiles"
  add_foreign_key "funding_sources", "accounts"
  add_foreign_key "funding_sources", "customers"
  add_foreign_key "invest_sets", "users"
  add_foreign_key "invest_transactions", "invest_sets"
  add_foreign_key "profiles", "users"
end
