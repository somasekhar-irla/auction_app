class CreateBids < ActiveRecord::Migration[8.0]
  def change
    create_table :bids do |t|
      t.string :uuid, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :user, null: false, foreign_key: true
      t.references :auction_item, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bids, [:amount, :user_id, :auction_item_id], :unique => true
  end
end
