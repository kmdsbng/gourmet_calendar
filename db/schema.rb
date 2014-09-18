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

ActiveRecord::Schema.define(version: 20140916233028) do

  create_table "event_ranges", force: true do |t|
    t.date     "start_on"
    t.integer  "start_hour"
    t.integer  "start_min"
    t.date     "end_on"
    t.integer  "end_hour"
    t.integer  "end_min"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_ranges", ["end_on"], name: "index_event_ranges_on_end_on", using: :btree
  add_index "event_ranges", ["start_on", "end_on"], name: "index_event_ranges_on_start_on_and_end_on", using: :btree

  create_table "event_sources", force: true do |t|
    t.string   "url",                                      null: false
    t.string   "title"
    t.string   "place_str"
    t.string   "range_str"
    t.string   "source_type"
    t.boolean  "event_created",            default: false
    t.boolean  "ignored",                  default: false
    t.boolean  "import_success",           default: true
    t.string   "import_error_code"
    t.text     "import_error_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_sources", ["url"], name: "index_event_sources_on_url", unique: true, using: :btree

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "place_str"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rel_event_event_sources", force: true do |t|
    t.integer  "event_id"
    t.integer  "event_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rel_event_event_sources", ["event_id"], name: "index_rel_event_event_sources_on_event_id", using: :btree
  add_index "rel_event_event_sources", ["event_source_id"], name: "index_rel_event_event_sources_on_event_source_id", using: :btree

  create_table "settings", force: true do |t|
    t.string   "name"
    t.integer  "num"
    t.string   "str"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name"], name: "index_settings_on_name", unique: true, using: :btree

end
