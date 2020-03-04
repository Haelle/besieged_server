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

ActiveRecord::Schema.define(version: 2020_03_04_144531) do

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

  create_table "buildings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "building_type"
    t.uuid "camp_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["camp_id"], name: "index_buildings_on_camp_id"
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
    t.string "pseudonym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.uuid "camp_id"
    t.integer "action_points", default: 0
    t.index ["account_id"], name: "index_characters_on_account_id"
    t.index ["camp_id"], name: "index_characters_on_camp_id"
  end

  create_table "ongoing_tasks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.json "params"
    t.integer "action_points_spent", default: 0
    t.integer "action_points_required", default: 1
    t.boolean "repeatable", default: false
    t.uuid "taskable_id"
    t.string "taskable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["taskable_id", "taskable_type"], name: "index_ongoing_tasks_on_taskable_id_and_taskable_type"
  end

  create_table "siege_machines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "damages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "camp_id"
    t.string "name"
    t.string "siege_machine_type"
    t.index ["camp_id"], name: "index_siege_machines_on_camp_id"
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.json "object"
    t.datetime "created_at"
    t.json "object_changes"
    t.string "item_subtype"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "buildings", "camps"
  add_foreign_key "castles", "camps"
  add_foreign_key "characters", "accounts"
end
