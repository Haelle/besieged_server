# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_18_214059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.boolean "admin", default: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "camps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "castles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "health_points"
    t.uuid "camp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_id"], name: "index_castles_on_camp_id"
  end

  create_table "characters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "pseudonyme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.uuid "camp_id"
    t.index ["account_id"], name: "index_characters_on_account_id"
    t.index ["camp_id"], name: "index_characters_on_camp_id"
  end

  create_table "siege_machines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "damages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "camp_id"
    t.string "name"
    t.index ["camp_id"], name: "index_siege_machines_on_camp_id"
  end

  add_foreign_key "castles", "camps"
  add_foreign_key "characters", "accounts"
end
