class BidsController < BaseController
  before_action :set_auction_item, only: %i[ create ]

  def create
    bid = Bid.new(bid_params)
    bid.auction_item = @auction_item
    bid.user = current_user
    if bid.save
      render_json(bid, code: :created)
    else
      respond_error(error_message: bid.errors.full_messages.to_sentence, code: :unprocessable_entity)
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def bid_params
      params.require(:bid).permit(:amount)
    end

    def set_auction_item
      @auction_item = AuctionItem.find_by(uuid: params.expect(:auction_item_uuid))
      respond_error(error_message: "AuctionItem not found with uuid #{params[:auction_item_uuid]}", code: :not_found) if @auction_item.blank?
    end
end
