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

ActiveRecord::Schema[8.0].define(version: 2025_08_07_154250) do
  create_table "currencies", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currency_exchange_types", force: :cascade do |t|
    t.integer "from_currency_id", null: false
    t.integer "to_currency_id", null: false
    t.string "exchange_rate_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_currency_id"], name: "index_currency_exchange_types_on_from_currency_id"
    t.index ["to_currency_id"], name: "index_currency_exchange_types_on_to_currency_id"
  end

  create_table "exchange_rate_requests", force: :cascade do |t|
    t.integer "currency_exchange_type_id", null: false
    t.integer "exchange_rate_id"
    t.string "failure_reason"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_exchange_type_id"], name: "index_exchange_rate_requests_on_currency_exchange_type_id"
    t.index ["exchange_rate_id"], name: "index_exchange_rate_requests_on_exchange_rate_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.integer "currency_exchange_type_id", null: false
    t.decimal "last_price", precision: 30, scale: 18
    t.decimal "bid_price", precision: 30, scale: 18
    t.decimal "ask_price", precision: 30, scale: 18
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_exchange_type_id"], name: "index_exchange_rates_on_currency_exchange_type_id"
  end

  add_foreign_key "currency_exchange_types", "currencies", column: "from_currency_id"
  add_foreign_key "currency_exchange_types", "currencies", column: "to_currency_id"
  add_foreign_key "exchange_rate_requests", "currency_exchange_types"
  add_foreign_key "exchange_rate_requests", "exchange_rates"
  add_foreign_key "exchange_rates", "currency_exchange_types"
end
