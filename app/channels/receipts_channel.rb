class ReceiptsChannel < ApplicationCable::Channel

  def subscribed
    # binding.pry
    stream_from "receipts_channel_#{params[:restaurant_id]}"
  end

  def unsubscribed
    puts 'unsubscribed'
  end


end
