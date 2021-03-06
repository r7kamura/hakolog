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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120504160249) do

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.string   "username"
    t.datetime "modified_at"
    t.datetime "synced_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "dropbox_id"
    t.string   "dropbox_session"
    t.string   "version"
  end

  add_index "blogs", ["username"], :name => "index_blogs_on_username"

  create_table "entries", :force => true do |t|
    t.string   "path"
    t.text     "body"
    t.integer  "blog_id",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "modified_at"
  end

  add_index "entries", ["path"], :name => "index_entries_on_path"

end
