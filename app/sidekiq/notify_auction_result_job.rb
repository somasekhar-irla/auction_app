class NotifyAuctionResultJob
  include Sidekiq::Job

  def perform
    end_time = Time.now
    start_time = end_time - 5.minutes
    auction_items = AuctionItem.where("highest_bid_id is not null and ((bid_end_time >= ? and bid_end_time < ?) || (bid_end_time >= ? and bid_end_time < ? and notified = ?))", start_time, end_time, Time.now.beginning_of_day, start_time, false)
    auction_items.each do |auction_item|
      if auction_item.winner_bid_id.blank?
        auction_item.winner_bid_id = auction_item.get_winner_bid&.id
        if auction_item.save
          notify_bid_winner(auction_item)
        else
          Rails.logger.info "Error: NotifyAuctionResultJob #{auction_item.errors.full_messages.to_sentence}"
        end
      elsif !auction_item.notified
        notify_bid_winner(auction_item)
      end
    end
  end

  def notify_bid_winner(auction_item)
    winner_bid = auction_item.winner_bid
    if winner_bid
      notify_payload = BidSerializer.new(winner_bid).serializable_hash
      # todo send email or publish to kafka or call external API to send notifications - not implemented now
    end
    auction_item.update_column(:notified, true)
  end
end
