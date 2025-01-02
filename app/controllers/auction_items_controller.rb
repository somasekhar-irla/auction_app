class AuctionItemsController < BaseController
  before_action :validate_iso8601_time, only: [ :create ]

  def index
    auction_items = AuctionItem.get_list(params[:page], params[:per])
    render_json(auction_items, meta: { total_records_count: AuctionItem.all.size })
  end

  def create
    auction_item = AuctionItem.new(auction_item_params)
    auction_item.user = current_user
    if auction_item.save
      render_json(auction_item, code: :created)
    else
      respond_error(error_message: auction_item.errors.full_messages.to_sentence, code: :unprocessable_entity)
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def auction_item_params
      params.require(:auction_item).permit(:title, :description, :starting_price, :min_selling_price, :bid_start_time, :bid_end_time)
    end

    def validate_iso8601_time
      [ :bid_start_time, :bid_end_time ].each do |key|
        value = params[:auction_item][key]
        unless value.present? && iso8601_valid?(value)
          respond_error(error_message: "#{key} must be a valid ISO 8601 datetime format", code: :bad_request)
          return
        end
      end
    end

    def iso8601_valid?(datetime)
      DateTime.iso8601(datetime.to_s)
      true
    rescue ArgumentError
      false
    end
end
