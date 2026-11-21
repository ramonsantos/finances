# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_21_180001) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "expense_categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "expenses_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower(name)", name: "index_expense_categories_on_lower_name", unique: true
  end

  create_table "expense_creator_results", force: :cascade do |t|
    t.integer "expense_creator_id", null: false
    t.text "raw_content", null: false
    t.boolean "success", default: false, null: false
    t.string "details", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_creator_id"], name: "index_expense_creator_results_on_expense_creator_id"
  end

  create_table "expense_creators", force: :cascade do |t|
    t.datetime "date", null: false
    t.integer "status", default: 0, null: false
    t.integer "expense_creator_results_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string "description", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.date "date", null: false
    t.boolean "fixed", default: false, null: false
    t.text "remark"
    t.integer "expense_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_method_id", null: false
    t.boolean "essential", default: false, null: false
    t.index ["date"], name: "index_expenses_on_date"
    t.index ["expense_category_id"], name: "index_expenses_on_expense_category_id"
    t.index ["payment_method_id"], name: "index_expenses_on_payment_method_id"
    t.check_constraint "amount >= 0.01", name: "expenses_amount_check"
  end

  create_table "loans", force: :cascade do |t|
    t.string "person", null: false
    t.string "description", null: false
    t.decimal "borrowed_amount", precision: 12, scale: 2, null: false
    t.decimal "received_amount", precision: 12, scale: 2
    t.date "loan_date", null: false
    t.date "received_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "borrowed_amount >= 0.01", name: "loans_borrowed_amount_check"
    t.check_constraint "received_amount IS NULL OR received_amount >= 0.01", name: "loans_received_amount_check"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.integer "expenses_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower(name)", name: "index_payment_methods_on_lower_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "expense_creator_results", "expense_creators", on_delete: :cascade
  add_foreign_key "expenses", "expense_categories", on_delete: :restrict
  add_foreign_key "expenses", "payment_methods", on_delete: :restrict
end
