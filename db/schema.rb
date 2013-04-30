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

ActiveRecord::Schema.define(:version => 20130430045509) do

  create_table "bans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "created_by_id"
    t.datetime "lifted_at"
    t.text     "reason"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "bans", ["created_by_id"], :name => "index_bans_on_created_by_id"
  add_index "bans", ["user_id"], :name => "index_bans_on_user_id"

  create_table "contents", :force => true do |t|
    t.integer  "link_id"
    t.integer  "user_id"
    t.text     "body"
    t.integer  "like_count", :default => 0
    t.datetime "deleted_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "contents", ["link_id"], :name => "index_contents_on_link_id"
  add_index "contents", ["user_id"], :name => "index_contents_on_user_id"

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
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "title"
    t.text     "summary"
    t.integer  "like_count", :default => 0
    t.boolean  "approved"
    t.datetime "deleted_at"
  end

  add_index "links", ["user_id"], :name => "index_links_on_user_id"

  create_table "notices", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "active",     :default => true
    t.text     "body"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "notices", ["user_id"], :name => "index_notices_on_user_id"

  create_table "posts", :force => true do |t|
    t.integer  "content_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "twitter_results", :force => true do |t|
    t.string   "tweet_created_at"
    t.string   "tweet_from_user"
    t.string   "tweet_from_user_id"
    t.string   "tweet_from_user_name"
    t.string   "tweet_geo"
    t.string   "tweet_id"
    t.string   "tweet_iso_language_code"
    t.string   "tweet_profile_image_url"
    t.string   "tweet_source"
    t.text     "tweet_text"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "link_id"
    t.integer  "content_id"
  end

  add_index "twitter_results", ["content_id"], :name => "index_twitter_results_on_content_id"
  add_index "twitter_results", ["link_id"], :name => "index_twitter_results_on_link_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "admin"
    t.string   "uid"
    t.string   "name"
    t.string   "provider"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "email"
    t.string   "birthday"
    t.text     "description"
    t.string   "image"
    t.string   "location"
    t.string   "gender"
    t.string   "twitter_url"
    t.string   "facebook_url"
    t.string   "google_url"
    t.string   "website_url"
  end

end
