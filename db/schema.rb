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

ActiveRecord::Schema.define(version: 20160228221914) do

  create_table "atbs", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "category",   limit: 4
    t.integer  "modifier",   limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "effect",     limit: 255, null: false
  end

  add_index "atbs", ["effect"], name: "index_atbs_on_effect", using: :btree
  add_index "atbs", ["name", "modifier"], name: "unique_attribute_name_modifier", unique: true, using: :btree

  create_table "heros", force: :cascade do |t|
    t.string   "static_name", limit: 255, null: false
    t.string   "name",        limit: 255, null: false
    t.integer  "rank",        limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "heros", ["name"], name: "hero_unique_name", unique: true, using: :btree
  add_index "heros", ["static_name", "name", "rank"], name: "hero_unique_name_rank", unique: true, using: :btree
  add_index "heros", ["static_name"], name: "hero_unique_static_name", unique: true, using: :btree

  create_table "skill_atbs", force: :cascade do |t|
    t.string   "value",      limit: 255, null: false
    t.integer  "target",     limit: 4,   null: false
    t.integer  "skill_id",   limit: 4,   null: false
    t.integer  "atb_id",     limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "skill_atbs", ["atb_id"], name: "index_skill_atbs_on_atb_id", using: :btree
  add_index "skill_atbs", ["skill_id", "atb_id"], name: "unique_skill_attribute", unique: true, using: :btree
  add_index "skill_atbs", ["skill_id"], name: "index_skill_atbs_on_skill_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "static_name", limit: 255,             null: false
    t.string   "name",        limit: 255,             null: false
    t.integer  "category",    limit: 4,               null: false
    t.integer  "cooldown",    limit: 4,   default: 0, null: false
    t.integer  "hero_id",     limit: 4,               null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "skills", ["hero_id", "name"], name: "hero_unique_skill_name", unique: true, using: :btree
  add_index "skills", ["hero_id", "static_name"], name: "hero_unique_skill_static_name", unique: true, using: :btree

  create_table "visitors", force: :cascade do |t|
    t.string  "address",      limit: 255,             null: false
    t.integer "todays_count", limit: 4,   default: 0
    t.date    "todays_date",                          null: false
  end

  add_index "visitors", ["address", "todays_date"], name: "visitors_timelime", unique: true, using: :btree
  add_index "visitors", ["address"], name: "index_visitors_on_address", using: :btree
  add_index "visitors", ["todays_date", "address"], name: "todays_visitors", unique: true, using: :btree
  add_index "visitors", ["todays_date"], name: "index_visitors_on_todays_date", using: :btree

end
