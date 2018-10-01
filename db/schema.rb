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

ActiveRecord::Schema.define(version: 2018_10_01_000738) do

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
    t.bigint "user_id", null: false
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
    t.string "guid"
    t.jsonb "trackpoints", default: [], null: false
    t.bigint "user_id", null: false
    t.bigint "place_id"
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.tsrange "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "singular", default: false, null: false
    t.decimal "longitude"
    t.decimal "latitude"
    t.index ["end_time"], name: "index_location_scrobbles_on_end_time"
    t.index ["guid"], name: "index_location_scrobbles_on_guid"
    t.index ["latitude"], name: "index_location_scrobbles_on_latitude"
    t.index ["longitude"], name: "index_location_scrobbles_on_longitude"
    t.index ["period"], name: "index_location_scrobbles_on_period", using: :gist
    t.index ["place_id"], name: "index_location_scrobbles_on_place_id"
    t.index ["source_type", "source_id"], name: "index_location_scrobbles_on_source_type_and_source_id"
    t.index ["start_time"], name: "index_location_scrobbles_on_start_time"
    t.index ["trackpoints"], name: "index_location_scrobbles_on_trackpoints", using: :gin
    t.index ["type", "category"], name: "index_location_scrobbles_on_type_and_category"
    t.index ["user_id"], name: "index_location_scrobbles_on_user_id"
  end

  create_table "place_matches", force: :cascade do |t|
    t.jsonb "source_fields", default: {}, null: false
    t.string "source_identifier"
    t.string "source_type"
    t.bigint "source_id"
    t.bigint "place_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_place_matches_on_place_id"
    t.index ["source_fields"], name: "index_place_matches_on_source_fields", using: :gin
    t.index ["source_identifier"], name: "index_place_matches_on_source_identifier"
    t.index ["source_type", "source_id"], name: "index_place_matches_on_source_type_and_source_id"
    t.index ["user_id"], name: "index_place_matches_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.string "street_1"
    t.string "street_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "category"
    t.text "description"
    t.string "service_identifier"
    t.string "guid"
    t.boolean "global"
    t.bigint "user_id", null: false
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at"
    t.index ["category"], name: "index_places_on_category"
    t.index ["guid"], name: "index_places_on_guid"
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
    t.bigint "user_id", null: false
    t.bigint "service_id"
    t.integer "scrobbles_count"
    t.datetime "last_scrobbled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disabled"], name: "index_scrobblers_on_disabled"
    t.index ["guid"], name: "index_scrobblers_on_guid"
    t.index ["schedule"], name: "index_scrobblers_on_schedule"
    t.index ["service_id"], name: "index_scrobblers_on_service_id"
    t.index ["type"], name: "index_scrobblers_on_type"
    t.index ["user_id"], name: "index_scrobblers_on_user_id"
  end

  create_table "scrobbles", force: :cascade do |t|
    t.string "type", null: false
    t.string "category", null: false
    t.jsonb "data", default: {}, null: false
    t.string "guid", null: false
    t.bigint "user_id", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.tsrange "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_scrobbles_on_category"
    t.index ["data"], name: "index_scrobbles_on_data", using: :gin
    t.index ["end_time"], name: "index_scrobbles_on_end_time"
    t.index ["guid"], name: "index_scrobbles_on_guid"
    t.index ["period"], name: "index_scrobbles_on_period", using: :gist
    t.index ["source_type", "source_id"], name: "index_scrobbles_on_source_type_and_source_id"
    t.index ["start_time"], name: "index_scrobbles_on_start_time"
    t.index ["type"], name: "index_scrobbles_on_type"
    t.index ["user_id"], name: "index_scrobbles_on_user_id"
  end

  create_table "service_caches", force: :cascade do |t|
    t.string "type"
    t.jsonb "data", default: {}, null: false
    t.bigint "service_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data"], name: "index_service_caches_on_data", using: :gin
    t.index ["service_id"], name: "index_service_caches_on_service_id"
    t.index ["type"], name: "index_service_caches_on_type"
  end

  create_table "services", force: :cascade do |t|
    t.string "provider", null: false
    t.string "name", null: false
    t.text "token", null: false
    t.text "secret"
    t.string "uid"
    t.text "refresh_token"
    t.jsonb "options", default: {}
    t.bigint "user_id", null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "global", default: false, null: false
    t.index ["provider"], name: "index_services_on_provider"
    t.index ["uid"], name: "index_services_on_uid"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "location_imports", "users"
  add_foreign_key "location_scrobbles", "places"
  add_foreign_key "location_scrobbles", "users"
  add_foreign_key "place_matches", "places"
  add_foreign_key "place_matches", "users"
  add_foreign_key "places", "services"
  add_foreign_key "places", "users"
  add_foreign_key "scrobblers", "services"
  add_foreign_key "scrobblers", "users"
  add_foreign_key "scrobbles", "users"
  add_foreign_key "service_caches", "services"
  add_foreign_key "services", "users"
end
