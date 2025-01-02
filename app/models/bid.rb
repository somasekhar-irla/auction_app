class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction_item
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :amount, uniqueness: { scope: [ :user, :auction_item ] }
  validate :valid_bid_duration
  validate :valid_bidder
  after_create :update_highest_bid

  def update_highest_bid
    highest_bid = auction_item.bids.order(amount: :desc, created_at: :asc).first
    auction_item.update_column(:highest_bid_id, highest_bid.id)
    AutoBidsJob.perform_async(auction_item.id)
  end

  private

  def valid_bid_duration
    start_time = auction_item.bid_start_time
    end_time = auction_item.bid_end_time
    errors.add(:base, "Auction item bid time is not started. Please try during bid duration") unless Time.now >= start_time && Time.now <= end_time
  end

  def valid_bidder
    errors.add(:base, "Bidder cannot be same as seller") if auction_item.user_id == user_id
  end
end
