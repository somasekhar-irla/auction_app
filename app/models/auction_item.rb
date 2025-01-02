class AuctionItem < ApplicationRecord
  belongs_to :user
  has_many :bids
  has_many :auto_bids
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :starting_price, :min_selling_price, presence: true, numericality: { greater_than: 0 }
  validate :bid_start_and_end_time
  validate :prices

  def self.get_list(page = 1, per = 25)
    AuctionItem.all.page(page).per(per)
  end

  def bid_start_time_iso8601
    bid_start_time.iso8601
  end

  def bid_end_time_iso8601
    bid_end_time.iso8601
  end

  def get_winner_bid
    (highest_bid&.amount.to_f > min_selling_price) && bid_end_time < Time.now ? highest_bid : nil
  end

  def winner_bid
    Bid.find(winner_bid_id) rescue nil
  end

  def highest_bid
    Bid.find(highest_bid_id) rescue nil
  end

  private

  def prices
    errors.add(:starting_price, "must be greater than min_selling_price") if starting_price < min_selling_price
  end

  def bid_start_and_end_time
    # errors.add(:bid_start_time, 'must be greater than Current time') if bid_start_time <= Time.now
    errors.add(:bid_end_time, "must be greater than bid_start_time") if bid_end_time < bid_start_time
  end
end
