class AutoBidsJob
  include Sidekiq::Job

  # AutoBid : Create bid for the closest maximum amount among all autobids
  def perform(auction_item_id)
    auction_item = AuctionItem.find(auction_item_id)
    return if auction_item.blank?

    # Step1: Get the current highest bid amount.
    highest_bid = auction_item.highest_bid
    initial_highest_bid_amount = (highest_bid.amount.to_f || auction_item.starting_price)

    # Step2: Get Autobids whose max amount is greater than current highest bid amount.
    auto_bids = auction_item.auto_bids.where("max_amount > ?", initial_highest_bid_amount).order(max_amount: :desc, created_at: :asc)
    auto_bids_arr = auto_bids.pluck(:uuid, :max_amount)
    return if auto_bids_arr.size <= 1

    top_first_auto_bid = auto_bids_arr[0].to_a
    top_second_auto_bid = auto_bids_arr[1].to_a
    bid_amounts = [ initial_highest_bid_amount, top_second_auto_bid[1].to_f, top_first_auto_bid[1].to_f ]

    # Step3: Create bid for top closest amount among all auto bids and skip for the lesser amount autobids
    if bid_amounts.max > initial_highest_bid_amount
      close_bid_amount = closest_to_max(bid_amounts)
      final_bid_amount = close_bid_amount < top_first_auto_bid[1].to_f ? close_bid_amount+1 : close_bid_amount
      auto_bid = AutoBid.find_by(uuid: top_first_auto_bid[0])
      bid = Bid.create(amount: final_bid_amount, user_id: auto_bid.user_id, auction_item_id: auto_bid.auction_item_id)
      Rails.logger.info "Error: Autobid #{ab.id} - #{bid.errors.full_messages.to_sentence}" if bid.errors.present?
    end
  end

  def closest_to_max(array)
    return nil if array.empty?

    max_num = array.max
    filter_array = array.sort.tap(&:pop)
    closest = filter_array.select { |num| num <= max_num }.max
    closest
  end
end
