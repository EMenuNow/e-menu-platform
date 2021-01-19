class BasketsController < ApplicationController

  before_action :set_path_and_restaurant

  def update
    basket_service = BasketService.new(@restaurant, current_patron, cookies['emenu_basket'])

    if params[:discount_code]
      action = basket_service.apply_discount_code(params[:discount_code])
      notice = "#{params[:discount_code].present? ? 'Code applied' : 'Code removed'}"
      alert = "Invalid code"
    end

    if params[:add_to_basket]
      action = basket_service.add_to_basket(params[:main_item], params[:items]&.split(','), params[:note]&.gsub('|||','.'))
      notice = "Added item to basket"
      alert = "Invalid item"
    end

    if params[:remove_from_basket]
      action = basket_service.remove_from_basket(params[:uuid])
      notice = "Removed item from basket"
      alert = "Invalid item"
    end

    respond_to do |format|
      if action
        format.html { redirect_to restaurant_path(@path), notice: notice || "Success" } 
      else
        format.html { redirect_to restaurant_path(@path), alert: alert || "Error" }
      end
    end   
  end

  private

  def set_path_and_restaurant
    @menu_id = params[:menu_id]
    @path = params[:path]
    @restaurant = Restaurant.find_by(path: @path)

  end
end
