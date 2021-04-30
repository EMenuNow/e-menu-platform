class OrderController < ApplicationController
  def index
    @path = params[:path]
    redirect_to restaurant_path(@path), status: 301
  end

  private 

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
   