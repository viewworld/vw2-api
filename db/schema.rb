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

ActiveRecord::Schema.define(version: 20160112150701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forms", force: :cascade do |t|
    t.string   "name"
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "forms", ["data"], name: "index_forms_on_data", using: :gin

  create_table "organisations", force: :cascade do |t|
    t.string   "name"
    t.string   "use"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "form_id"
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reports", ["data"], name: "index_reports_on_data", using: :gin
  add_index "reports", ["form_id"], name: "index_reports_on_form_id", using: :btree

  create_table "texts", force: :cascade do |t|
    t.string   "title"
    t.string   "hint"
    t.string   "default_value"
    t.integer  "form_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "texts", ["form_id"], name: "index_texts_on_form_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "timezone"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "reports", "forms"
  add_foreign_key "texts", "forms"
end
