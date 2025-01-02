class BidSerializer < ActiveModel::Serializer
  attributes :uuid, :amount

  belongs_to :auction_item

  attribute :user do
    self.object.user.email
  end
end
