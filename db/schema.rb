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

ActiveRecord::Schema.define(version: 2020_05_24_152209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expense_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "expenses_count", default: 0
    t.index ["user_id"], name: "index_expense_categories_on_user_id"
  end

  create_table "expense_creator_results", force: :cascade do |t|
    t.text "raw_content"
    t.boolean "success"
    t.string "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "expense_creator_id"
    t.index ["expense_creator_id"], name: "index_expense_creator_results_on_expense_creator_id"
  end

  create_table "expense_creators", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "expense_creator_results_count", default: 0
    t.index ["user_id"], name: "index_expense_creators_on_user_id"
  end

  create_table "expense_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "expenses_count", default: 0
    t.index ["user_id"], name: "index_expense_groups_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.date "date"
    t.boolean "fixed"
    t.text "remark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "place_id"
    t.bigint "expense_group_id"
    t.text "description_ciphertext"
    t.text "amount_ciphertext"
    t.bigint "expense_category_id"
    t.index ["expense_category_id"], name: "index_expenses_on_expense_category_id"
    t.index ["expense_group_id"], name: "index_expenses_on_expense_group_id"
    t.index ["place_id"], name: "index_expenses_on_place_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "loans", force: :cascade do |t|
    t.date "loan_date"
    t.date "received_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description_ciphertext"
    t.text "person_ciphertext"
    t.text "borrowed_amount_ciphertext"
    t.text "received_amount_ciphertext"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "expenses_count", default: 0
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "expense_categories", "users"
  add_foreign_key "expense_creator_results", "expense_creators"
  add_foreign_key "expense_creators", "users"
  add_foreign_key "expense_groups", "users"
  add_foreign_key "expenses", "expense_categories"
  add_foreign_key "expenses", "expense_groups"
  add_foreign_key "expenses", "places"
  add_foreign_key "expenses", "users"
  add_foreign_key "loans", "users"
  add_foreign_key "places", "users"
end
