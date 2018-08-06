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

ActiveRecord::Schema.define(version: 2018_08_06_044147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "location_imports", force: :cascade do |t|
    t.string "guid"
    t.string "adapter"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_location_imports_on_guid"
    t.index ["user_id"], name: "index_location_imports_on_user_id"
  end

  create_table "location_scrobbles", force: :cascade do |t|
    t.string "type", null: false
    t.string "name"
    t.string "category"
    t.decimal "distance"
    t.text "description"
    t.jsonb "trackpoints", default: "[]", null: false
    t.bigint "place_id"
    t.bigint "user_id"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_import_id"
    t.index ["location_import_id"], name: "index_location_scrobbles_on_location_import_id"
    t.index ["place_id"], name: "index_location_scrobbles_on_place_id"
    t.index ["trackpoints"], name: "index_location_scrobbles_on_trackpoints", using: :gin
    t.index ["type", "category"], name: "index_location_scrobbles_on_type_and_category"
    t.index ["user_id"], name: "index_location_scrobbles_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "category"
    t.text "description"
    t.string "service_identifier"
    t.bigint "service_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_places_on_category"
    t.index ["name"], name: "index_places_on_name"
    t.index ["service_id"], name: "index_places_on_service_id"
    t.index ["service_identifier"], name: "index_places_on_service_identifier"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "scrobblers", force: :cascade do |t|
    t.text "options"
    t.string "type", null: false
    t.string "name"
    t.string "schedule"
    t.string "guid", null: false
    t.boolean "disabled", default: false, null: false
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "last_scrobbled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disabled"], name: "index_scrobblers_on_disabled"
    t.index ["schedule"], name: "index_scrobblers_on_schedule"
    t.index ["service_id"], name: "index_scrobblers_on_service_id"
    t.index ["type"], name: "index_scrobblers_on_type"
    t.index ["user_id"], name: "index_scrobblers_on_user_id"
  end

  create_table "scrobbles", force: :cascade do |t|
    t.string "type", null: false
    t.jsonb "data"
    t.string "guid", null: false
    t.bigint "user_id"
    t.bigint "scrobbler_id"
    t.datetime "scrobbled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_scrobbles_on_guid"
    t.index ["scrobbled_at"], name: "index_scrobbles_on_scrobbled_at"
    t.index ["scrobbler_id"], name: "index_scrobbles_on_scrobbler_id"
    t.index ["type"], name: "index_scrobbles_on_type"
    t.index ["user_id"], name: "index_scrobbles_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "provider", null: false
    t.string "name", null: false
    t.text "token", null: false
    t.text "secret"
    t.string "uid"
    t.text "refresh_token"
    t.bigint "user_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "options"
    t.index ["provider"], name: "index_services_on_provider"
    t.index ["uid"], name: "index_services_on_uid"
    t.index ["user_id"], name: "index_services_on_user_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "location_imports", "users"
  add_foreign_key "location_scrobbles", "location_imports"
  add_foreign_key "location_scrobbles", "places"
  add_foreign_key "location_scrobbles", "users"
  add_foreign_key "places", "services"
  add_foreign_key "places", "users"
  add_foreign_key "scrobblers", "users"
  add_foreign_key "scrobbles", "users"
  add_foreign_key "services", "users"
end
