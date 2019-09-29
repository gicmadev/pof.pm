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

ActiveRecord::Schema.define(version: 20190929111123) do

  create_table "clicks", force: :cascade do |t|
    t.string   "referer",          limit: 255
    t.text     "ip",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shortened_url_id", limit: 4
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.string   "shortcode",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "from_bitly"
    t.integer  "bitly_clicks", limit: 4
    t.integer  "clicks_count", limit: 4
  end

end
