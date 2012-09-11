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

ActiveRecord::Schema.define(:version => 20120818073000) do

  create_table "games", :force => true do |t|
    t.text     "info"
    t.integer  "quiz_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.string   "category"
    t.text     "data"
    t.integer  "points",                  :default => 1
    t.integer  "quiz_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "quizzes", :force => true do |t|
    t.string   "name"
    t.string   "grades"
    t.boolean  "activated",  :default => false
    t.integer  "school_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_digest"
    t.string   "level"
    t.string   "key"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "school_id"
    t.integer  "grade"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
