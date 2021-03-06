# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140926160238) do

  create_table "analyses", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geo_region_id"
  end

  create_table "analysis_geo_region_scores", force: true do |t|
    t.integer  "analysis_id"
    t.integer  "geo_region_id"
    t.decimal  "risk_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "analyzed_geo_blocks", force: true do |t|
    t.integer  "geo_region_id"
    t.decimal  "risk_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "analysis_id"
  end

  create_table "food_sources", force: true do |t|
    t.string   "business_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "healthy"
  end

  create_table "geo_regions", force: true do |t|
    t.decimal  "nw_lat"
    t.decimal  "nw_lon"
    t.decimal  "se_lat"
    t.decimal  "se_lon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "analysis_id"
    t.integer  "analyzed_geo_block_id"
    t.decimal  "center_lat"
    t.decimal  "center_lon"
    t.float    "risk_score"
    t.text     "income_data"
    t.integer  "census_tract_id"
  end

  create_table "geographic_data_points", force: true do |t|
    t.integer  "geo_region_id"
    t.string   "type"
    t.string   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "located_food_sources", force: true do |t|
    t.decimal  "lat"
    t.decimal  "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "analysis_id"
    t.integer  "price_rank"
    t.integer  "food_source_id"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
