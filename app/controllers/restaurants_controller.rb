class RestaurantsController < ApplicationController
  layout 'powered_by'
  before_action :get_restaurant
  before_action :basket_service

  def show
    @menu = @restaurant.menus_live_menus
    @menu = @restaurant.menus_live_menus.where(:id => params[:menu_id]) if params[:menu_id].present?
    @menu2 = get_serialized_menu(@restaurant)
  end

  def welcome
    redirect_to restaurant_path(@restaurant.path) if patron_signed_in?
  end

  private

  def get_restaurant
    @path = params[:id]
    @restaurant = Restaurant.where("lower(path) = ?", @path.downcase).first
  end

  def basket_service
    cookies.delete :emenu_basket if cookies['emenu_basket'].present? && @restaurant.id != JSON.parse(cookies['emenu_basket'])['key'].split('-').first.to_i
    @basket_service = BasketService.new(@restaurant, current_patron, cookies['emenu_basket'])
    cookies['emenu_basket'] = @basket_service.get_cookie
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
