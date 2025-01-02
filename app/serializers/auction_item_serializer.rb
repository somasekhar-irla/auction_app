class AuctionItemSerializer < ActiveModel::Serializer
  attributes :uuid, :title, :description, :starting_price, :created_at, :updated_at
  attribute :min_selling_price, if: :can_display?

  attribute :bid_start_time do
    self.object.bid_start_time_iso8601
  end

  attribute :bid_end_time do
    self.object.bid_end_time_iso8601
  end

  attribute :user do
    self.object.user.email
  end

  # Display only to the User under profile section - Not implemented
  def can_display?
    false
  end
end
