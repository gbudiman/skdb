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

ActiveRecord::Schema.define(version: 20160319191337) do

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

  create_table "countries", force: :cascade do |t|
    t.string "short", limit: 255, null: false
    t.string "mid",   limit: 255, null: false
    t.string "long",  limit: 255, null: false
  end

  add_index "countries", ["long"], name: "index_countries_on_long", unique: true, using: :btree
  add_index "countries", ["mid"], name: "index_countries_on_mid", unique: true, using: :btree
  add_index "countries", ["short"], name: "index_countries_on_short", unique: true, using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string  "input_code",  limit: 255,                   null: false
    t.string  "reward",      limit: 255,                   null: false
    t.boolean "is_expired",                default: false
    t.text    "instruction", limit: 65535,                 null: false
    t.text    "credits",     limit: 65535,                 null: false
  end

  add_index "coupons", ["input_code", "reward"], name: "index_coupons_on_input_code_and_reward", unique: true, using: :btree

  create_table "equip_stats", force: :cascade do |t|
    t.integer  "equip_id",   limit: 4,               null: false
    t.integer  "category",   limit: 4,               null: false
    t.integer  "value",      limit: 4,               null: false
    t.integer  "variance",   limit: 4,   default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "atb",        limit: 255,             null: false
  end

  add_index "equip_stats", ["equip_id", "category", "atb", "value"], name: "index_equip_stats_on_equip_id_and_category_and_atb_and_value", unique: true, using: :btree

  create_table "equips", force: :cascade do |t|
    t.integer  "rank",        limit: 4,   null: false
    t.string   "name",        limit: 255
    t.integer  "slot",        limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "acquisition", limit: 255
  end

  add_index "equips", ["name"], name: "index_equips_on_name", unique: true, using: :btree

  create_table "hero_teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "heros", force: :cascade do |t|
    t.string   "static_name", limit: 255, null: false
    t.string   "name",        limit: 255, null: false
    t.integer  "rank",        limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "element",     limit: 4
    t.string   "category",    limit: 255
    t.string   "acquisition", limit: 255
  end

  add_index "heros", ["name"], name: "hero_unique_name", unique: true, using: :btree
  add_index "heros", ["static_name", "name", "rank"], name: "hero_unique_name_rank", unique: true, using: :btree
  add_index "heros", ["static_name"], name: "hero_unique_static_name", unique: true, using: :btree

  create_table "ip_countries", force: :cascade do |t|
    t.integer "address_start", limit: 8, null: false
    t.integer "address_end",   limit: 8, null: false
    t.integer "country_id",    limit: 4, null: false
  end

  add_index "ip_countries", ["address_end"], name: "index_ip_countries_on_address_end", unique: true, using: :btree
  add_index "ip_countries", ["address_start"], name: "index_ip_countries_on_address_start", unique: true, using: :btree
  add_index "ip_countries", ["country_id"], name: "index_ip_countries_on_country_id", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "slot",       limit: 4,                   null: false
    t.string   "value",      limit: 255,                 null: false
    t.integer  "hero_id",    limit: 4,                   null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "deviation",              default: false
  end

  add_index "recommendations", ["hero_id", "slot"], name: "index_recommendations_on_hero_id_and_slot", unique: true, using: :btree

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

  create_table "stats", force: :cascade do |t|
    t.integer  "hero_id",    limit: 4
    t.integer  "name",       limit: 4, null: false
    t.integer  "datapoint",  limit: 4, null: false
    t.integer  "value",      limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "stats", ["hero_id", "name", "datapoint"], name: "unique_hero_stat", unique: true, using: :btree
  add_index "stats", ["hero_id"], name: "index_stats_on_hero_id", using: :btree

  create_table "summarized_visitors", force: :cascade do |t|
    t.date     "todays_date",            null: false
    t.integer  "visit_count",  limit: 4, null: false
    t.integer  "unique_count", limit: 4, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "summarized_visitors", ["todays_date"], name: "index_summarized_visitors_on_todays_date", unique: true, using: :btree

  create_table "team_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiers", force: :cascade do |t|
    t.integer  "category",   limit: 4,   null: false
    t.string   "value",      limit: 255, null: false
    t.integer  "hero_id",    limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tiers", ["hero_id", "category"], name: "index_tiers_on_hero_id_and_category", unique: true, using: :btree

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
