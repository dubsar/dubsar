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

ActiveRecord::Schema.define(:version => 20120305094619) do

  create_table "accounts", :id => false, :force => true do |t|
    t.integer "id",        :null => false
    t.text    "user_name"
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "documents", :id => false, :force => true do |t|
    t.integer "id",      :null => false
    t.text    "content"
  end

  create_table "emailables", :id => false, :force => true do |t|
    t.integer "id",        :null => false
    t.integer "entity_id", :null => false
    t.integer "thing_id",  :null => false
  end

  add_index "emailables", ["entity_id", "thing_id"], :name => "emailables_entity_id_key", :unique => true

  create_table "emails", :id => false, :force => true do |t|
    t.integer "id",    :null => false
    t.text    "email"
  end

  create_table "entities", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "entity_ids", :force => true do |t|
  end

# Could not dump table "entity_types" because of following StandardError
#   Unknown type 'name' for column 'relname'

  create_table "institutions", :id => false, :force => true do |t|
    t.integer "id",   :null => false
    t.text    "name"
  end

  create_table "media", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "people", :id => false, :force => true do |t|
    t.integer "id",   :null => false
    t.text    "name"
  end

  create_table "posts", :id => false, :force => true do |t|
    t.integer "id",      :null => false
    t.text    "title"
    t.text    "content"
  end

  create_table "properties", :id => false, :force => true do |t|
    t.integer "id",        :null => false
    t.integer "entity_id", :null => false
    t.integer "thing_id",  :null => false
  end

  add_index "properties", ["entity_id", "thing_id"], :name => "properties_entity_id_key", :unique => true

  create_table "property_ids", :force => true do |t|
  end

# Could not dump table "property_types" because of following StandardError
#   Unknown type 'name' for column 'relname'

  create_table "searches", :id => false, :force => true do |t|
    t.integer  "id",                      :null => false
    t.integer  "item_id"
    t.text     "item_relation"
    t.text     "item_descriptive_column"
    t.text     "description"
    t.tsvector "content"
  end

  add_index "searches", ["content"], :name => "search_idx"

  create_table "tags", :id => false, :force => true do |t|
    t.text    "text"
    t.integer "weight"
  end

  create_table "thing_ids", :force => true do |t|
  end

# Could not dump table "thing_types" because of following StandardError
#   Unknown type 'name' for column 'relname'

  create_table "things", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

# Could not dump table "type_hierarchies" because of following StandardError
#   Unknown type 'name' for column 'child'

  create_table "users", :force => true do |t|
    t.text     "email"
    t.text     "crypted_password"
    t.text     "salt"
    t.text     "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

  add_index "users", ["email"], :name => "users_email_key", :unique => true

  create_table "videos", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "youtube_accounts", :id => false, :force => true do |t|
    t.integer "id",        :null => false
    t.text    "user_name"
    t.date    "checked"
  end

  add_index "youtube_accounts", ["user_name"], :name => "youtube_accounts_user_name_key", :unique => true

  create_table "youtube_videos", :id => false, :force => true do |t|
    t.integer "id",                :null => false
    t.text    "youtube_id"
    t.text    "youtube_user_name"
    t.text    "title"
    t.text    "description"
    t.date    "published"
    t.date    "updated"
  end

  add_index "youtube_videos", ["youtube_id"], :name => "youtube_videos_youtube_id_key", :unique => true

end
