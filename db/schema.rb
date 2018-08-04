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

ActiveRecord::Schema.define(version: 2018_08_04_170545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "scrobblers", "users"
  add_foreign_key "scrobbles", "users"
  add_foreign_key "services", "users"
end
