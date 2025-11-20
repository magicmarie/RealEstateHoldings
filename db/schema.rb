# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_11_20_160743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "address", "city", "state", "zip_code"], name: "idx_on_client_id_address_city_state_zip_code_54d40e2fe2", unique: true
    t.index ["client_id"], name: "index_buildings_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clients_on_name", unique: true
  end

  create_table "custom_field_definitions", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "field_name"
    t.integer "field_type"
    t.text "enum_options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "field_name"], name: "index_custom_field_definitions_on_client_id_and_field_name", unique: true
    t.index ["client_id"], name: "index_custom_field_definitions_on_client_id"
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.bigint "custom_field_definition_id", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id", "custom_field_definition_id"], name: "idx_on_building_id_custom_field_definition_id_0a6e4bbdb6", unique: true
    t.index ["building_id"], name: "index_custom_field_values_on_building_id"
    t.index ["custom_field_definition_id"], name: "index_custom_field_values_on_custom_field_definition_id"
  end

  add_foreign_key "buildings", "clients"
  add_foreign_key "custom_field_definitions", "clients"
  add_foreign_key "custom_field_values", "buildings"
  add_foreign_key "custom_field_values", "custom_field_definitions"
end
