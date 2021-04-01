

class PrintersChannel < ApplicationCable::Channel

  def subscribed
    # binding.pry
    stream_from "printers_channel_#{params[:restaurant_id]}_#{params[:server_token]}"
    pi_interface = PiInterface.find_or_create_by(server_token: params[:server_token], restaurant_id: params[:restaurant_id]) 
    pi_interface.version = params[:version] if params[:version].present?
    pi_interface.online = true
    pi_interface.save

  end

  def unsubscribed
    puts 'unsubscribed'
    pi_interface = PiInterface.find_by(server_token: params[:server_token], restaurant_id: params[:restaurant_id]) 
    pi_interface.online = false
    pi_interface.save
  end

  def speak(data)
     puts data.inspect

  end
  def print_confirm(data)

    receipt = Receipt.find(data['receipt_id'])
    receipt.update_print_status(data['print_status'])




  end
  
  def lsusb(data)
    pi_interface = PiInterface.find_by(server_token: data['server_token'], restaurant_id: data['restaurant_id']) 
    pi_interface.lsusb = data['message']
    pi_interface.save
  end

end