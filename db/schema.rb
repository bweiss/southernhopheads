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

ActiveRecord::Schema.define(:version => 20131212143600) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "allow_comments"
    t.string   "location"
    t.boolean  "event"
    t.boolean  "published",      :default => false
    t.boolean  "featured",       :default => false
  end

  create_table "beers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "brewery_id"
    t.decimal  "abv",         :precision => 5, :scale => 2
    t.integer  "srm"
    t.integer  "ibu"
    t.string   "style"
    t.boolean  "featured",                                  :default => false
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "beers", ["name"], :name => "index_beers_on_name"

  create_table "breweries", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.string   "website"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "breweries", ["name"], :name => "index_breweries_on_name", :unique => true

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "location"
    t.boolean  "allow_comments", :default => true
    t.boolean  "featured",       :default => false
    t.boolean  "published",      :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "events", ["start_at"], :name => "index_events_on_start_at"

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
    t.integer  "sort_value"
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.string   "payment_type", :default => "single", :null => false
    t.datetime "payment_date"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "payments", ["user_id"], :name => "index_payments_on_user_id", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "forum_id"
    t.integer  "user_id"
    t.boolean  "sticky"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "allow_comments", :default => true
  end

  create_table "reviews", :force => true do |t|
    t.decimal  "score",      :precision => 3, :scale => 1
    t.text     "content"
    t.integer  "beer_id"
    t.integer  "user_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "name"
    t.string   "location"
    t.text     "whats_brewing"
    t.boolean  "email_visible"
    t.text     "favorite_beers"
    t.boolean  "email_new_events"
    t.boolean  "email_event_reminders"
    t.boolean  "email_new_comments"
    t.boolean  "email_about_articles",   :default => true
    t.boolean  "email_about_events",     :default => true
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
