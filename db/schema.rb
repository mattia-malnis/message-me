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

ActiveRecord::Schema[8.0].define(version: 2024_11_27_144114) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chat_profiles", force: :cascade do |t|
    t.bigint "chat_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "profile_id"], name: "index_chat_profiles_on_chat_id_and_profile_id", unique: true
    t.index ["chat_id"], name: "index_chat_profiles_on_chat_id"
    t.index ["profile_id"], name: "index_chat_profiles_on_profile_id"
  end

  create_table "chats", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_chats_on_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "profile_id"
    t.bigint "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["profile_id"], name: "index_messages_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name", null: false
    t.string "nickname", null: false
    t.string "bio"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "textsearchable_col", type: :tsvector, as: "to_tsvector('english'::regconfig, (((((COALESCE(name, ''::character varying))::text || ' '::text) || (COALESCE(nickname, ''::character varying))::text) || ' '::text) || COALESCE(('@'::text || (nickname)::text), ''::text)))", stored: true
    t.string "token"
    t.index "lower((nickname)::text)", name: "index_profiles_on_lower_nickname", unique: true
    t.index ["textsearchable_col"], name: "index_profiles_on_textsearchable_col", using: :gin
    t.index ["token"], name: "index_profiles_on_token", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "profile_id"
    t.text "endpoint", null: false
    t.text "p256dh_key", null: false
    t.text "auth_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endpoint"], name: "index_subscriptions_on_endpoint", unique: true
    t.index ["profile_id"], name: "index_subscriptions_on_profile_id"
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
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
