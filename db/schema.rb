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

ActiveRecord::Schema.define(version: 20151227130449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_format_types", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grid_ids", force: true do |t|
    t.integer "house_info_id"
    t.integer "zoom"
    t.integer "id_lat"
    t.integer "id_lng"
  end

  add_index "grid_ids", ["house_info_id", "zoom"], name: "index_grid_ids_on_house_info_id_and_zoom", unique: true, using: :btree
  add_index "grid_ids", ["house_info_id"], name: "index_grid_ids_on_house_info_id", using: :btree
  add_index "grid_ids", ["zoom", "id_lat", "id_lng"], name: "index_grid_ids_on_zoom_and_id_lat_and_id_lng", using: :btree

  create_table "house_info_changes", force: true do |t|
    t.integer  "house_info_id"
    t.string   "parser"
    t.string   "feature_id"
    t.integer  "price"
    t.integer  "year"
    t.integer  "floor"
    t.string   "floor_text"
    t.integer  "buliding_format_id"
    t.integer  "material_id"
    t.float    "plat_of_land"
    t.float    "float_area"
    t.integer  "num_of_badroom"
    t.integer  "num_of_livingroom"
    t.integer  "num_of_restroom"
    t.string   "address"
    t.float    "coord_longitude"
    t.float    "coord_latitude"
    t.date     "changed_date"
    t.integer  "pre_change_id"
    t.string   "source_url"
    t.boolean  "error_during_parsing", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "house_info_changes", ["changed_date"], name: "index_house_info_changes_on_changed_date", using: :btree
  add_index "house_info_changes", ["feature_id"], name: "index_house_info_changes_on_feature_id", using: :btree
  add_index "house_info_changes", ["house_info_id"], name: "index_house_info_changes_on_house_info_id", using: :btree
  add_index "house_info_changes", ["parser", "feature_id", "changed_date"], name: "index_parser_featureid_changedat_on_changes", unique: true, using: :btree
  add_index "house_info_changes", ["parser", "feature_id"], name: "index_house_info_changes_on_parser_and_feature_id", using: :btree
  add_index "house_info_changes", ["pre_change_id"], name: "index_house_info_changes_on_pre_change_id", using: :btree

  create_table "house_infos", force: true do |t|
    t.string   "feature_id"
    t.integer  "price"
    t.integer  "year"
    t.integer  "floor"
    t.string   "floor_text"
    t.integer  "buliding_format_id"
    t.integer  "material_id"
    t.float    "plat_of_land"
    t.float    "float_area"
    t.integer  "num_of_badroom"
    t.integer  "num_of_livingroom"
    t.integer  "num_of_restroom"
    t.string   "address"
    t.float    "coord_longitude"
    t.float    "coord_latitude"
    t.datetime "resource_at"
    t.integer  "using_source_id"
    t.string   "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "house_infos", ["feature_id"], name: "index_house_infos_on_feature_id", using: :btree

  create_table "material_types", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "source_house_infos", force: true do |t|
    t.integer  "house_info_id"
    t.boolean  "is_marged",            default: false
    t.string   "parser"
    t.string   "feature_id"
    t.integer  "price"
    t.integer  "year"
    t.integer  "floor"
    t.string   "floor_text"
    t.integer  "buliding_format_id"
    t.integer  "material_id"
    t.float    "plat_of_land"
    t.float    "float_area"
    t.integer  "num_of_badroom"
    t.integer  "num_of_livingroom"
    t.integer  "num_of_restroom"
    t.string   "address"
    t.float    "coord_longitude"
    t.float    "coord_latitude"
    t.datetime "ecxuted_at"
    t.datetime "marged_at"
    t.string   "source_url"
    t.boolean  "error_during_parsing", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "ecxuted_date"
  end

  add_index "source_house_infos", ["ecxuted_at"], name: "index_source_house_infos_on_ecxuted_at", using: :btree
  add_index "source_house_infos", ["ecxuted_date"], name: "index_source_house_infos_on_ecxuted_date", using: :btree
  add_index "source_house_infos", ["feature_id"], name: "index_source_house_infos_on_feature_id", using: :btree
  add_index "source_house_infos", ["marged_at"], name: "index_source_house_infos_on_marged_at", using: :btree
  add_index "source_house_infos", ["parser", "feature_id", "ecxuted_date"], name: "index_parser_featureid_ecxuteddate_on_source", unique: true, using: :btree

end
