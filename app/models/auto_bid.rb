class AutoBid < ApplicationRecord
  belongs_to :user
  belongs_to :auction_item
  validates :max_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_amount, uniqueness: { scope: [ :user, :auction_item ] }
  validate :valid_bidder

  private

  def valid_bidder
    errors.add(:base, "Bidder cannot be same as seller") if self.auction_item.user_id == user_id
  end
end
