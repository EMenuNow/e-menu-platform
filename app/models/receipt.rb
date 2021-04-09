class Receipt < ApplicationRecord
  belongs_to :restaurant
  belongs_to :order
  after_create :broadcast
  after_create :creation_print
  after_create :item_breakdown
  has_many :screen_items
  belongs_to :discount_code, optional: true
  delegate :id, to: :restaurant, prefix: true

  after_create :email_receipt

  # def mylogger
  #   @@my_logger ||= Logger.new("#{Rails.root}/log/mylog.log")
  # end

  def order_id
    id.to_s.truncate(4, omission: '')
  end

  def update_print_status(status)
    self.find_grouped_receipts.each do |x|
      x.print_status = status
      x.save
    end
  end

  def item_breakdown
    item_screens = ItemScreen.where(restaurant_id: restaurant_id).joins(:item_screen_type).where("item_screen_types.key <> 'FULL'")
    if item_screens.present?
      items['items'].each do |item|
        ScreenItem.create(restaurant_id: restaurant_id, menu_id: item['menu_id'], receipt_id: id, item_screen_type_key: item['item_screen_type_key'], uuid: item['uuid'])
        ScreenItem.create(secondary: true, restaurant_id: restaurant_id, menu_id: item['menu_id'], receipt_id: id, item_screen_type_key: item['secondary_item_screen_type_key'], uuid: item['uuid']) if item['secondary_item_screen_type_key'].present?
      end
      broadcast_items
      creation_print_grouped('FOOD') if items['items'].select{|s| s['item_screen_type_key'] == 'FOOD'}.present?
      creation_print_grouped('DRINK') if items['items'].select{|s| s['item_screen_type_key'] == 'DRINK'}.present?
      secondary_creation_print_grouped('FOOD') if items['items'].select{|s| s['secondary_item_screen_type_key'] == 'FOOD'}.present?
      secondary_creation_print_grouped('DRINK') if items['items'].select{|s| s['secondary_item_screen_type_key'] == 'DRINK'}.present?
    end
  end

  def broadcast_items
    @printers = Printer.where(restaurant_id: restaurant_id)

    item_screen_foods = ItemScreen.where(restaurant_id: restaurant_id  ).joins(:item_screen_type).where("item_screen_types.key = 'FOOD'")
    item_screen_food = item_screen_foods.first if item_screen_foods.present?
    if item_screen_food.present?
    
     html_food  = ApplicationController.render(partial: "manager/live/order_items", locals: {grouped: item_screen_food.grouped,  printers: @printers, restaurant_id: restaurant_id, item_screen_type_key: 'FOOD' })
      ActionCable.server.broadcast("food_items_channel_#{restaurant_id}", {html: html_food, message: "New"})
    end 

    item_screen_drinks = ItemScreen.where(restaurant_id: restaurant_id  ).joins(:item_screen_type).where("item_screen_types.key = 'DRINK'")
    item_screen_drink = item_screen_drinks.first if item_screen_drinks.present?
    if item_screen_drink.present?
      html_drinks  = ApplicationController.render(partial: "manager/live/order_items", locals: { grouped: item_screen_drink.grouped,  printers: @printers, restaurant_id: restaurant_id, item_screen_type_key: 'DRINK' })
      ActionCable.server.broadcast("drink_items_channel_#{restaurant_id}", {html: html_drinks, message: "New"})
    end
  end

  def creation_print
    item_screens = ItemScreen.where(restaurant_id: restaurant_id).joins(:item_screen_type).where("item_screen_types.key = 'FULL'")
    item_screen = nil
    item_screen = item_screens.first if item_screens.present?

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

  def broadcast(message: "Refresh")
    @printers = Printer.where(restaurant_id: restaurant_id)
    html  = ApplicationController.render(partial: "manager/live/order_items", locals: { printers: @printers, restaurant: Restaurant.find(restaurant_id) })
    # binding.pry
    data = {html: html, sound_file_path: ActionController::Base.helpers.asset_path('order-bell.wav'), message: message}   
    ActionCable.server.broadcast("receipts_channel_#{restaurant_id}", data)
  end

  def print_receipt(printer, action='print')
    print_receipt = ""
    self.find_grouped_receipts.each do |x|
      print_receipt += ApplicationController.render(partial: "manager/live/order_items_print", locals: { receipt: x, restaurant: restaurant_id })
    end.empty? and begin
      return
    end
    print_receipt = print_receipt.gsub("&amp;","&").gsub(restaurant.currency_symbol,"")
    header = ""
    header << "Name: #{name}\n" if delivery_or_collection != 'tableservice' 
    header << "Time: #{collection_time}\n" if delivery_or_collection != 'tableservice' 
    header << "Type: #{delivery_or_collection}\n" 
    header << "Table Number: #{table_number}\n" if delivery_or_collection == 'tableservice' 
    header << "Tel: #{telephone}\n" if telephone.present? 
    header << "Address: #{address}\n" if delivery_or_collection == 'delivery'
    header << "\n\n"
    data = {receipt_id: id, print_type: printer.print_type, action: action, header: header, print_receipt: print_receipt, printer_vendor: printer.vendor, printer_product: printer.product}

    ActionCable.server.broadcast("printers_channel_#{restaurant_id}_#{printer.pi_interface_server_token}", data)
    update_print_status('Sent to printer')
  end

  def email_receipt
    if email.present?
      ApplicationMailer.receipt(id).deliver_now
    end
  end

  def creation_print_grouped(item_screen_type_key)
    item_screens = ItemScreen.where(restaurant_id: restaurant_id).joins(:item_screen_type).where("item_screen_types.key = ?", item_screen_type_key)
    item_screen = nil
    item_screen = item_screens.first if item_screens.present?

    if item_screen.present?
      buzz = item_screen.buzz_on_new
      print = item_screen.on_new
      action = nil
      action = 'print' if print
      action = 'buzz' if buzz
      action = 'print_buzz' if print and buzz
      if action.present? and item_screen.printer.present? and item_screen.grouped
        print_receipt_grouped(item_screen.printer, item_screen_type_key, action)
      end
    end
  end

  def print_receipt_grouped(printer, item_screen_type_key, action='print')
    print_receipt = ""
    self.find_grouped_receipts.each do |x|
      print_receipt += ApplicationController.render(partial: "manager/live/order_item_screen_specific_print", locals: {grouped: true, screen_item: self, restaurant: restaurant_id, item_screen_type_key: item_screen_type_key })
    end.empty? and begin
      return
    end
    print_receipt = print_receipt.gsub("&amp;","&").gsub(restaurant.currency_symbol,"")
    header = ""
    header << "Name: #{name}\n" if delivery_or_collection != 'tableservice' 
    header << "Time: #{collection_time}\n" if delivery_or_collection != 'tableservice' 
    header << "Type: #{delivery_or_collection}\n" 
    header << "Table Number: #{table_number}\n" if delivery_or_collection == 'tableservice' 
    header << "Tel: #{telephone}\n" if telephone.present? 
    header << "Address: #{address}\n" if delivery_or_collection == 'delivery'
    header << "\n\n"
    data = {receipt_id: id, print_type: printer.print_type, action: action, header: header, print_receipt: print_receipt, printer_vendor: printer.vendor, printer_product: printer.product}
   # mylogger.debug("PRINTING PRIMARY: #{printer.inspect}")
    ActionCable.server.broadcast("printers_channel_#{restaurant_id}_#{printer.pi_interface_server_token}", data)
    update_print_status('Sent to printer')
  end

  def secondary_creation_print_grouped(secondary_item_screen_type_key)
    item_screens = ItemScreen.where(restaurant_id: restaurant_id).joins(:item_screen_type).where("item_screen_types.key = ?", secondary_item_screen_type_key)
    item_screen = nil
    item_screen = item_screens.first if item_screens.present?

    if item_screen.present?
      buzz = item_screen.buzz_on_new
      print = item_screen.on_new
      action = nil
      action = 'print' if print
      action = 'buzz' if buzz
      action = 'print_buzz' if print and buzz
      if action.present? and item_screen.printer.present? and item_screen.grouped
        secondary_print_receipt_grouped(item_screen.printer, secondary_item_screen_type_key, action)
      end
    end
  end

  def secondary_print_receipt_grouped(printer, secondary_item_screen_type_key, action='print')
    
    print_receipt = ApplicationController.render(partial: "manager/live/order_item_screen_specific_print_secondary", locals: {grouped: true, screen_item: self, restaurant: restaurant_id, secondary_item_screen_type_key: secondary_item_screen_type_key })
    print_receipt = print_receipt.gsub("&amp;","&").gsub(restaurant.currency_symbol,"")
    header = ""
    header << "Name: #{name}\n" if delivery_or_collection != 'tableservice' 
    header << "Time: #{collection_time}\n" if delivery_or_collection != 'tableservice' 
    header << "Type: #{delivery_or_collection}\n" 
    header << "Table Number: #{table_number}\n" if delivery_or_collection == 'tableservice' 
    header << "Tel: #{telephone}\n" if telephone.present? 
    header << "Address: #{address}\n" if delivery_or_collection == 'delivery'
    header << "\n\n"
    data = {receipt_id: id, print_type: printer.print_type, action: action, header: header, print_receipt: print_receipt, printer_vendor: printer.vendor, printer_product: printer.product}
  #  mylogger.debug("PRINTING SECONDARY: #{printer.inspect}")
    ActionCable.server.broadcast("printers_channel_#{restaurant_id}_#{printer.pi_interface_server_token}", data)
    update_print_status('Sent to printer')
  end

  def zreport
    
    #i = items['items'].present? ? items['items'].map{|s| {id: s['menu_id'], total: (s['total']*100.to_f).to_i, optional_ids: s['optionals']}} : []
    i = []
    if items['items'].present?
      items['items'].each do |item|
        menu = Menu.find(item['menu_id'])
      i << {
        id: item['menu_id'], 
        total: (item['total']*100.to_f).to_i, 
        optional_ids: item['optionals'],
        menu_name: menu.name,
        menu_parent_name: menu.parent.name
      }
       
      end
    end
    
    c = items['items'].present? ? items['items'].count : 0

    {
      basket_total: basket_total,
      item_count: c,
      items: i,
      source: source,
      delivery_or_collection: delivery_or_collection,
      delivery_fee: delivery_fee
    }
  end

  def find_grouped_receipts(seconds = 300)
    return [self] if self.table_number.blank? || !self.group_order
    receipts = self.restaurant.receipts.where(table_number: self.table_number).limit(100).group_by {|x| Time.at((x.created_at.to_f / seconds).round * seconds).utc }.select{|x,y|y.map(&:id).include?(self.id)}&.values&.first&.uniq(&:uuid)&.sort_by{|x|x.created_at}
    DateTime.now.to_i > receipts.first.created_at.to_i + seconds ? receipts : []
  end

  def self.group_by_time(receipts, seconds = 300)
    receipts.group_by {|x| (time = Time.at((x.created_at.to_f / seconds).round * seconds).utc).to_s + (x.group_order ? nil : x.id ).to_s }.sort_by{|x,y|y.first.created_at}
  end

end
