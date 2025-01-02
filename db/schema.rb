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

ActiveRecord::Schema[8.0].define(version: 2024_12_30_065601) do
  create_table "auction_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.decimal "starting_price", precision: 10, scale: 2, null: false
    t.decimal "min_selling_price", precision: 10, scale: 2, null: false
    t.datetime "bid_start_time", null: false
    t.datetime "bid_end_time", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "highest_bid_id"
    t.bigint "winner_bid_id"
    t.boolean "notified", default: false
    t.index ["highest_bid_id"], name: "index_auction_items_on_highest_bid_id"
    t.index ["user_id"], name: "index_auction_items_on_user_id"
    t.index ["winner_bid_id"], name: "index_auction_items_on_winner_bid_id"
  end

  create_table "auto_bids", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.decimal "max_amount", precision: 10, scale: 2, null: false
    t.bigint "user_id", null: false
    t.bigint "auction_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_item_id"], name: "index_auto_bids_on_auction_item_id"
    t.index ["max_amount", "user_id", "auction_item_id"], name: "index_auto_bids_on_max_amount_and_user_id_and_auction_item_id", unique: true
    t.index ["user_id"], name: "index_auto_bids_on_user_id"
  end

  create_table "bids", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "user_id", null: false
    t.bigint "auction_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amount", "user_id", "auction_item_id"], name: "index_bids_on_amount_and_user_id_and_auction_item_id", unique: true
    t.index ["auction_item_id"], name: "index_bids_on_auction_item_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "auction_items", "bids", column: "highest_bid_id"
  add_foreign_key "auction_items", "bids", column: "winner_bid_id"
  add_foreign_key "auction_items", "users"
  add_foreign_key "auto_bids", "auction_items"
  add_foreign_key "auto_bids", "users"
  add_foreign_key "bids", "auction_items"
  add_foreign_key "bids", "users"
end
