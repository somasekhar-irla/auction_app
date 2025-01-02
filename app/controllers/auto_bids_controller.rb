class AutoBidsController < BaseController
  before_action :set_auction_item, only: %i[ create ]

  def create
    auto_bid = AutoBid.new(auto_bid_params)
    auto_bid.auction_item = @auction_item
    auto_bid.user = current_user
    if auto_bid.save
      render_json(auto_bid, code: :created)
    else
      respond_error(error_message: auto_bid.errors.full_messages.to_sentence, code: :unprocessable_entity)
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def auto_bid_params
      params.require(:auto_bid).permit(:max_amount)
    end

    def set_auction_item
      @auction_item = AuctionItem.find_by(uuid: params.expect(:auction_item_uuid))
      respond_error(error_message: "AuctionItem not found with uuid #{params[:auction_item_uuid]}", code: :not_found) if @auction_item.blank?
    end
end
