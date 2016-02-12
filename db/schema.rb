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

ActiveRecord::Schema.define(version: 20160211135059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forms", force: :cascade do |t|
    t.string   "name"
    t.jsonb    "data"
    t.boolean  "active",                default: false
    t.boolean  "verification_required", default: false
    t.string   "verification_default",  default: "verified"
    t.boolean  "locked",                default: false
    t.text     "groups",                default: [],                      array: true
    t.text     "order",                 default: [],                      array: true
    t.datetime "deleted_at"
    t.integer  "organisation_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "forms", ["data"], name: "index_forms_on_data", using: :gin
  add_index "forms", ["deleted_at"], name: "index_forms_on_deleted_at", using: :btree
  add_index "forms", ["organisation_id"], name: "index_forms_on_organisation_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "organisation_id"
    t.integer  "parent_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "groups", ["organisation_id"], name: "index_groups_on_organisation_id", using: :btree
  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree

  create_table "organisations", force: :cascade do |t|
    t.string   "name"
    t.string   "use"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "braintree_customer_id"
  end

  create_table "report_files", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "form_id"
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reports", ["data"], name: "index_reports_on_data", using: :gin
  add_index "reports", ["form_id"], name: "index_reports_on_form_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "timezone_name"
    t.integer  "role",            default: 3
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

  add_foreign_key "forms", "organisations"
  add_foreign_key "groups", "organisations"
  add_foreign_key "reports", "forms"
  add_foreign_key "users", "groups"
end
