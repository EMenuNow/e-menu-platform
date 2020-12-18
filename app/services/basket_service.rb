class BasketService < ApplicationController
  include TablesHelper

  attr_accessor :discount_code, :service_types, :services_enabled, :service_selected, :basket

  def initialize(restaurant, basket)

    @restaurant = restaurant
    
    @cookie = @basket = (basket || { key: "#{@restaurant.id}-#{SecureRandom.uuid}" }.to_json)
    @basket_item_total ||= 0

    set_services_enabled

    key = JSON.parse(@basket)['key']
    
    key_restaurant_id = key.split('-').first.to_i

    key = JSON.parse(@basket)['key']
    @basket_db = Basket.where(key: key).first_or_create
    if @basket_db.contents.present?
      @basket_ids = @basket_db.contents
      @basket = basket_build(@basket_ids['ids'])
      @basket_item_count = @basket_ids['count']
      @basket_item_total = @basket['items'].map{|d| d['total']}.inject(:+)
      apply_discount_code(@basket_db.discount_code)
    end
  end
  
  def apply_discount_code(code)
    if code.present?
      @discount_code = @restaurant.discount_codes.is_active?.code_matches?(code).first
      return if @discount_code.blank?
      @basket_db.update_attribute(:discount_code, code)
      @basket_item_total = @discount_code.apply_discount_to_total(@basket_item_total)
    else
      @basket_db.update_attribute(:discount_code, "")
    end
  end

  def get_cookie
    @cookie
  end

  def get_basket_db
    @basket_db
  end

  def get_basket_item_count
    @basket_item_count
  end

  def get_basket_item_total
    @basket_item_total
  end

  def add_to_basket(main_item, items, note)
    @basket = @basket_db.contents
    basket_ids =  @basket.present? ? @basket['ids'] : []

    items = items&.split(',')
    note = note&.gsub('|||','.')

    menu_item = Menu.find(main_item)
    optionals = CustomListItem.where(id: items)

    sort_order = @restaurant.custom_list_ids
    lookup = {}
    sort_order.each_with_index do |item, index|
      lookup[item] = index
    end

    cl = optionals.sort_by do |item|
      lookup.fetch(item.custom_list_id)
    end

    total = ("%.2f" % menu_item.price_a).to_f
    total += cl.map{|s| ("%.2f" % s.price).to_f }.inject(:+) if optionals.present?
    uuid = SecureRandom.uuid

    basket_ids << {uuid: uuid, total: total.round(2), note: note ,item: menu_item.id, optionals: cl.map{|s| s.id }, item_screen_type_key: menu_item.item_screen_type_key, menu_id: menu_item.id, item_screen_type_name: menu_item.item_screen_type_name }
    @basket_db.contents = {
      restaurant: @restaurant.id,
      count: basket_ids.count,
      # items: basket_items,
      ids: basket_ids
    }
    @basket_db.save

  end

  def get_menu_item
    @menu_item
  end

  def remove_from_basket(item_uuid)
    remove_basket_ids = @basket_db.contents['ids'].select{|a| a['uuid'] == item_uuid}.first
    @menu_item = Menu.find(remove_basket_ids['item'])

    basket_ids = @basket_db.contents['ids'].reject{|a| a['uuid'] == item_uuid}
    @basket_db.contents = {
      restaurant: @restaurant.id,
      count: basket_ids.count,
      # items: basket_items,
      ids: basket_ids 
    }
    @basket_db.save
    @basket = @basket_db.contents
  end
  
  def basket_build(ids)
    basket_items = []
    ids.each do |id|
      menu_item = Menu.find(id['item'])
      optionals = CustomListItem.where(id: id['optionals'])
      
      sort_order = @restaurant.custom_list_ids
      lookup = {}
      sort_order.each_with_index do |item, index|
        lookup[item] = index
      end

      cl = optionals.sort_by do |item|
        lookup.fetch(item.custom_list_id)
      end
      basket_items << {'uuid' => id['uuid'], 'total' => id['total'], 'note' => id['note'] ,'item' => "<i>#{menu_item.parent.name}</i> - <strong>#{menu_item.name}</strong>" , 'optionals' => cl.map{|s| "- <strong>#{s.name}</strong>" }, 'item_screen_type_name' => menu_item.item_screen_type_name, 'item_screen_type_key' => menu_item.item_screen_type_key, 'menu_id' => menu_item.id, 'secondary_item_screen_type_name' => menu_item.secondary_item_screen_type_name, 'secondary_item_screen_type_key' => menu_item.secondary_item_screen_type_key }
    end

    { 'items' => basket_items }

  end

  private

  def set_services_enabled
    @service_types = ['Collection', 'Delivery', 'Table Service']
    @services_enabled = []
    @services_enabled << ['Collection', 'collection'] if is_takeaway?(@restaurant) 
    @services_enabled << ['Delivery', 'delivery'] if is_delivery?(@restaurant)
    @services_enabled << ['Table Service', 'tableservice'] if is_tableservice?(@restaurant) and @restaurant.is_open
  end


end
