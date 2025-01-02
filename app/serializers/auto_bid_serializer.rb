class AutoBidSerializer < ActiveModel::Serializer
  attributes :uuid, :max_amount
  belongs_to :auction_item

  attribute :user do
    self.object.user.email
  end
end
