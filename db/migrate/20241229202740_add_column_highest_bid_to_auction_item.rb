class AddColumnHighestBidToAuctionItem < ActiveRecord::Migration[8.0]
  def change
    add_reference :auction_items, :highest_bid, foreign_key: {to_table: :bids}
  end
end
