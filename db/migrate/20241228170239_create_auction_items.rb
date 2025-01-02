class CreateAuctionItems < ActiveRecord::Migration[8.0]
  def change
    create_table :auction_items do |t|
      t.string :uuid, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :starting_price, precision: 10, scale: 2, null: false
      t.decimal :min_selling_price, precision: 10, scale: 2, null: false
      t.datetime :bid_start_time, null: false
      t.datetime :bid_end_time, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :auction_items, :title, :unique => true
    add_index :auction_items, :uuid, :unique => true
  end
end
