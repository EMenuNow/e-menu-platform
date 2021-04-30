class KitchensChannel < ApplicationCable::Channel

  def subscribed
    # binding.pry
    stream_from "kitchens_channel_#{params[:restaurant_id]}"
  end

  def unsubscribed
    puts 'unsubscribed'
  end


end
