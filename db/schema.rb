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

ActiveRecord::Schema.define(:version => 20130320063118) do

  create_table "facebook_contents", :force => true do |t|
    t.integer  "link_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "like_count"
  end

  add_index "facebook_contents", ["link_id"], :name => "index_facebook_contents_on_link_id"
  add_index "facebook_contents", ["user_id"], :name => "index_facebook_contents_on_user_id"

  create_table "likes", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "links", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.text     "summary"
    t.integer  "like_count"
  end

  add_index "links", ["user_id"], :name => "index_links_on_user_id"

  create_table "posts", :force => true do |t|
    t.integer  "content_id"
    t.string   "content_type"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "twitter_contents", :force => true do |t|
    t.integer  "link_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "like_count"
  end

  add_index "twitter_contents", ["link_id"], :name => "index_twitter_contents_on_link_id"
  add_index "twitter_contents", ["user_id"], :name => "index_twitter_contents_on_user_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "admin"
    t.string   "uid"
    t.string   "name"
    t.string   "provider"
  end

end
