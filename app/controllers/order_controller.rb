class OrderController < ApplicationController
  before_action :authenticate_user!, except: [:pay, :index, :add_to_basket, :stripe,:stripex, :receipt, :basket, :checkout,:checkoutx, :remove_from_basket]
  skip_before_action :verify_authenticity_token, only: %i[stripe]
  before_action :stripe_parameters, only: [:checkout, :pay, :stripe]

  def index
    @path = params[:path]
    redirect_to restaurant_path(@path), status: 301
    @restaurant = Restaurant.find_by(path: @path)
    @menu = @restaurant.menus_live_menus
    @menu2 = get_serialized_menu(@restaurant)

    cookies.delete :emenu_basket if cookies['emenu_basket'].present? && @restaurant.id != JSON.parse(cookies['emenu_basket'])['key'].split('-').first.to_i
    
    @basket_service = BasketService.new(@restaurant, cookies['emenu_basket'])

    if @basket_service.get_basket_db&.contents.present?
      @basket = @basket_service.get_basket_db
      @basket_item_count = @basket_service.get_basket_item_count
      @basket_item_total = @basket_service.get_basket_item_total
    else
      cookies['emenu_basket'] = @basket_service.get_basket
    end
  end

  def add_to_basket
    # my_logger ||= Logger.new("#{Rails.root}/log/basket.log")
    # binding.pry
    path = params[:path]
    @restaurant = Restaurant.find_by(path: path)

    basket_service = BasketService.new(@restaurant, cookies['emenu_basket'])
    @basket = basket_service.get_basket_db.contents

    basket_ids =  @basket.present? ? @basket['ids'] : []
    basket_service.add_to_basket(params[:main_item], params[:items]&.split(','), params[:note]&.gsub('|||','.'))

    menu_id = params[:menu_id] if params[:menu_id].present?
  
    return_path = restaurant_path_path(path)

    return_path = order_menu_path(path, menu_id) if feature_match('menu_in_sections', @restaurant.features) && menu_id.present?
    return_path = order_menu_section_path(path, menu_id, params[:section_id]) if feature_match('menu_in_sections', @restaurant.features) && menu_id.present? && params[:section_id].present?

    respond_to do |format|
      format.html { redirect_to return_path, notice: 'Added to basket' }
    end

  end

  def remove_from_basket
    @path = params[:path]

    @restaurant = Restaurant.find_by(path: @path)
    basket_service = BasketService.new(@restaurant, cookies['emenu_basket'])
    
    if basket_service.get_basket
      basket_service.remove_from_basket(params[:uuid])
    end

    menu_id = params[:menu_id]
    section_id = params[:section_id]
    
    if params[:menu_id].blank? or params[:section_id].blank?
      ids = basket_service.get_menu_item.ancestry.split('/')
      menu_id = ids.first
      section_id = ids[1]
    end

    path = restaurant_path_path(@path)
    path = order_menu_section_path(@path, menu_id, section_id) if feature_match('menu_in_sections', @restaurant.features) and params[:section_id].present?
    path = order_menu_path(@path, menu_id) if feature_match('menu_in_sections', @restaurant.features) and params[:section_id].blank?

    respond_to do |format|
      format.html { redirect_to path, notice: 'Removed from basket' }
    end
  end

  def checkout
    checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)

    @delivery_time_options = @restaurant.available_times

    if @basket
      @basket_item_count = @basket_service.get_basket_item_count
      @basket_item_total = @basket_service.get_basket_item_total
    end
  end

  def pay
    @redirect_domain =  Rails.application.credentials.dig(:apple_pay, :redirect_domain)

    @checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)

    @total_payment = params[:total].to_f
    @payment_in_pence = (@total_payment * 100).to_i
    @publish_stripe_api_key = @restaurant.stripe_pk_api_key

    @payment_intent = @checkout_service.create_transaction
  end

  def stripe
    error = false
    success = false

    checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)
    
    begin
      @receipt = checkout_service.generate_receipt
      cookies.delete :emenu_basket
    rescue Exception => e
      error = true
    end

    respond_to do |format|
      if error
        format.html { redirect_to checkout_path(@path), alert: "Payment Error: #{e.message}" } 
        format.json { render json: {ok: true, error: true, path: order_receipt_path(@path, @receipt.uuid)} }
      else
        format.html { redirect_to order_receipt_path(@path, @receipt.uuid), notice: "Payment Successful" }
        format.json { render json: {ok: true, error: false, path: order_receipt_path(@path, @receipt.uuid)} }
      end
    end   
  end  
  
  def receipt
    @uuid = params[:uuid]
    @path = params[:path]
    @restaurant = Restaurant.find_by(path: @path)
    @receipt = Receipt.find_by(uuid: @uuid)
  end

  private 

  def stripe_parameters
    @parameters = params.slice(:service_type, :total, :price, :service_type, :collection_time, :table_number, :name, :telephone, :email, :house_number,
    :street, :postcode, :basket, :delivery_fee, :apple_and_google, :stripe_success_token)
    @path = params[:path]
    @restaurant = Restaurant.find_by(path: @path)
    @basket_service = BasketService.new(@restaurant, cookies['emenu_basket'])
    @basket = @basket_service.get_basket_db
  end
  
  def feature_match(feature, restaurant_features)
    restaurant_features.map{|s| s.key.to_sym}.include?(feature.to_sym)
  end

  def get_serialized_menu restaurant
    Rails.cache.fetch("restaurant_order_menu_#{@restaurant.id}", expires_in: 3.hours) do
      active_ids = @restaurant.active_menu_ids
      @menu2 = @restaurant.menus_live_menus.where(root_node_id: active_ids).arrange_serializable(order: :position) do |parent, children|
        
      image = (parent.image if image.present?)  
        {
          id: parent.id,
          name: parent.name,
          node_type: parent.node_type,
          children: children,
          ancestry: parent.ancestry,
          css_class: parent.css_class,
          price_a: parent.price_a,
          image: image , 
          description: parent.description,
          custom_lists: parent.custom_lists,
          nutrition: parent.nutrition,
          provenance: parent.provenance, 
          calories: parent.calories,
          is_deleted: parent.is_deleted, 
          item_screen_type_id: parent.item_screen_type_id,
          item_screen_type_name: parent.item_screen_type_name,
          item_screen_type_key: parent.item_screen_type_key,

          secondary_item_screen_type_id: parent.secondary_item_screen_type_id,
          secondary_item_screen_type_name: parent.secondary_item_screen_type_name,
          secondary_item_screen_type_key: parent.secondary_item_screen_type_key
        }
      end
    end
  end
end
   