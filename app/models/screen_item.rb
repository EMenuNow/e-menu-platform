class ScreenItem < ApplicationRecord
  belongs_to :menu
  belongs_to :restaurant
  belongs_to :receipt

  after_create :creation_print


  def creation_print
    item_screens = ItemScreen.where(restaurant_id: restaurant_id).joins(:item_screen_type).where("item_screen_types.key = ?", item_screen_type_key)
    item_screen = nil
    item_screen = item_screens.first if item_screens.present?


    if !item_screen.grouped

      if item_screen.present?
        buzz = item_screen.buzz_on_new
        print = item_screen.on_new
        action = nil
        action = 'print' if print
        action = 'buzz' if buzz
        action = 'print_buzz' if print and buzz
        if action.present? and item_screen.printer.present? 
          print_receipt(item_screen.printer, action)
        end
      end
    end
  end


  def print_receipt(printer, action='print')
    
    print_receipt = ApplicationController.render(partial: "manager/live/order_item_screen_specific_print", locals: { grouped: false, screen_item: self, restaurant: restaurant_id })
    print_receipt = print_receipt.gsub("&amp;","&").gsub(restaurant.currency_symbol,"")
    header = ""
    header << "Name: #{receipt.name}\n" if receipt.delivery_or_collection != 'tableservice' 
    header << "Time: #{receipt.collection_time}\n" if receipt.delivery_or_collection != 'tableservice' 
    header << "Type: #{receipt.delivery_or_collection}\n" 
    header << "Table Number: #{receipt.table_number}\n" if receipt.delivery_or_collection == 'tableservice' 
    header << "Tel: #{receipt.telephone}\n" if receipt.telephone.present? 
    header << "Address: #{receipt.address}\n" if receipt.delivery_or_collection == 'delivery'
    header << "\n\n"
    data = {print_type: printer.print_type, action: action, header: header, print_receipt: print_receipt, printer_vendor: printer.vendor, printer_product: printer.product}

    ActionCable.server.broadcast("printers_channel_#{restaurant_id}_#{printer.pi_interface_server_token}", data)
  end



end
