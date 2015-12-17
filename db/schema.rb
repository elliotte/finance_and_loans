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

ActiveRecord::Schema.define(version: 20151217075034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.date     "repdate"
  end

  add_index "comments", ["report_id"], name: "index_comments_on_report_id", using: :btree

  create_table "disclosures", force: :cascade do |t|
    t.text     "body"
    t.string   "type"
    t.integer  "report_id"
    t.string   "added_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.string   "title"
  end

  add_index "disclosures", ["report_id"], name: "index_disclosures_on_report_id", using: :btree

  create_table "ledgers", force: :cascade do |t|
    t.string   "type"
    t.string   "user_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "opening_balance"
    t.integer  "user_id"
    t.string   "drive_folder"
    t.string   "invoice_template_file_link"
  end

  add_index "ledgers", ["user_id"], name: "index_user_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "report_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.date     "repdate"
    t.string   "filelink"
  end

  add_index "notes", ["report_id"], name: "index_notes_on_report_id", using: :btree

  create_table "readers", force: :cascade do |t|
    t.integer  "report_id"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "readers", ["report_id"], name: "index_readers_on_report_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "report_type"
    t.string   "format"
    t.date     "current_end"
    t.date     "comparative_end"
    t.string   "drive_folder"
    t.string   "skydrive_folder"
  end

  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.string   "type"
    t.decimal  "amount"
    t.string   "monea_tag"
    t.string   "mi_tag"
    t.integer  "ledger_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "currency"
    t.date     "acc_date"
    t.decimal  "vat",               default: 0.0
    t.string   "invoice_file_link"
    t.boolean  "paid",              default: true
  end

  add_index "transactions", ["ledger_id"], name: "index_transactions_on_ledger_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "uid"
    t.string   "refresh_token"
  end

  create_table "values", force: :cascade do |t|
    t.integer  "report_id"
    t.date     "repdate"
    t.string   "mitag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",        default: "TbValue"
    t.decimal  "amount"
    t.string   "description"
    t.string   "ifrstag"
    t.integer  "number"
  end

  add_index "values", ["report_id"], name: "index_values_on_report_id", using: :btree

  create_table "viewers", force: :cascade do |t|
    t.integer  "ledger_id"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "viewers", ["ledger_id"], name: "index_viewers_on_ledger_id", using: :btree

  add_foreign_key "readers", "reports"
  add_foreign_key "viewers", "ledgers"
end
