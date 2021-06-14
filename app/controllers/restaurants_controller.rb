class RestaurantsController < ApplicationController
  layout 'powered_by'
  before_action :get_restaurant
  before_action :basket_service
  before_action :get_categories

  def show
    @menu = @restaurant.menus_live_menus
    @menu_availability = @menu.select{|m| m.node_type == "menu"}.select{|m| m.is_available?}.map{|m| m.id}
    @menu = @restaurant.menus_live_menus.where(:id => params[:menu_id]) if params[:menu_id].present?
    @menu2 = get_serialized_menu(@restaurant)

    if params[:filter] == 'clear'
      clear_cookie
    else
      update_cookie
      restore_cookie
    end
  end
  
  def filter
    restore_cookie
  end
  
  def welcome
    redirect_to restaurant_path(@restaurant.path) if patron_signed_in?
  end
  
  private
  
  def get_restaurant
    @path = params[:id] || params[:restaurant_id]
    if @path !~ /\A[a-z\-0-9]*\z/
      redirect_to restaurant_path(@path.downcase), status: :moved_permanently
    end 
    @restaurant = Restaurant.where("lower(path) = ?", @path.downcase).first
  end
  
  def basket_service
    cookies.delete :emenu_basket if cookies['emenu_basket'].present? && @restaurant.id != JSON.parse(cookies['emenu_basket'])['key'].split('-').first.to_i
    @basket_service = BasketService.new(@restaurant, current_patron, cookies['emenu_basket'])
    cookies['emenu_basket'] = @basket_service.get_cookie
  end
  
  def get_categories
    @diets = Dietary.all.sort_by &:id
    @allergens = Allergen.all.sort_by &:id
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
          categories: parent.menu_item_categorisations,
          categorisations: parent.menu_item_categorisations_menus,
          nutrition: parent.nutrition,
          provenance: parent.provenance, 
          calories: parent.calories,
          is_deleted: parent.is_deleted,
          is_available: parent.is_available?,
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

  def update_cookie
    update_cookie_with_param(:dietary_ids, params[:dietary_ids])
    update_cookie_with_param(:contains_allergen_ids, params[:contains_allergen_ids])
    update_cookie_with_param(:may_contain_allergen_ids, params[:may_contain_allergen_ids])
  end

  def restore_cookie
    restore_param_from_cookie(:dietary_ids)
    restore_param_from_cookie(:contains_allergen_ids)
    restore_param_from_cookie(:may_contain_allergen_ids)
  end
  
  def clear_cookie
    clear_param_from_cookie(:dietary_ids)
    clear_param_from_cookie(:contains_allergen_ids)
    clear_param_from_cookie(:may_contain_allergen_ids)
  end

  def update_cookie_with_param(param_name, ids)
    if params[param_name]
      value = (ids.class == Array) ? ids.join('&') : ids
      cookies[param_name] = { :value => value, :expires => 2.weeks.from_now }
    else
      cookies.delete(param_name)
    end
  end
  
  def restore_param_from_cookie(param_name)
    if cookies[param_name]
      params[param_name] = cookies[param_name].split('&')
    end
  end
  
  def clear_param_from_cookie(param_name)
    if cookies[param_name]
      cookies.delete(param_name)
    end
  end

end
