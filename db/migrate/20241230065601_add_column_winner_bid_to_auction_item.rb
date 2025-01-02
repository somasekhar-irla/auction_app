class AddColumnWinnerBidToAuctionItem < ActiveRecord::Migration[8.0]
  def change
    add_reference :auction_items, :winner_bid, foreign_key: {to_table: :bids}
    add_column :auction_items, :notified, :boolean, default: false
  end
end
