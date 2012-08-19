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

ActiveRecord::Schema.define(:version => 20120819164549) do

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.integer  "school_id"
    t.integer  "era_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "books", ["era_id"], :name => "index_books_on_era_id"
  add_index "books", ["school_id"], :name => "index_books_on_school_id"

  create_table "eras", :force => true do |t|
    t.string   "name"
    t.integer  "start_year"
    t.integer  "end_year"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "eras", ["school_id"], :name => "index_eras_on_school_id"

  create_table "games", :force => true do |t|
    t.text     "info"
    t.integer  "quiz_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.integer  "category"
    t.text     "data"
    t.integer  "points"
    t.integer  "quiz_id"
    t.integer  "book_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "questions", ["book_id"], :name => "index_questions_on_book_id"
  add_index "questions", ["quiz_id"], :name => "index_questions_on_quiz_id"

  create_table "quizzes", :force => true do |t|
    t.string   "name"
    t.integer  "grade"
    t.boolean  "activated",  :default => true
    t.integer  "school_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "quizzes", ["school_id"], :name => "index_quizzes_on_school_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "level",           :limit => 2
    t.string   "key"
    t.integer  "region_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
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

  add_index "students", ["school_id"], :name => "index_students_on_school_id"

end
