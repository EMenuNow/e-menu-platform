class CheckoutsController < ApplicationController
  layout 'powered_by'
  before_action :get_restaurant
  before_action :get_basket
  before_action :stripe_parameters, only: [:index, :create, :pay, :stripe]
  skip_before_action :verify_authenticity_token, only: %i[stripe, create]

  def index
    checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)

    @delivery_day_options = @restaurant.available_days
    @delivery_availability = @restaurant.availability
    @delivery_time_options = @delivery_availability[0][:times]

    if @basket
      @basket_item_count = @basket_service.get_basket_item_count
      @basket_item_total = @basket_service.get_basket_item_total
    end
  end

  def create
    t = Time.new
    offset = @parameters["date_offset"].to_i
    due_time = @parameters["collection_time"]
    dtm = @restaurant.opening_time_delay_time_minutes.minutes
    btm = @restaurant.opening_time_kitchen_delay_minutes.minutes
    if due_time == "ASAP" or @parameters["service_type"] == 'tableservice'
      @parameters["due_date"] = t + dtm + btm
    else
      d = t + offset.day
      @parameters["due_date"] = Time.parse("#{d.year}-#{d.month}-#{d.day} #{due_time}:00").in_time_zone(@restaurant.time_zone) + t.utc_offset - t.in_time_zone(@restaurant.time_zone).utc_offset
    end
    @checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)

    render json: @checkout_service.create_checkout_session
  end
  
  def receipt
    cookies.delete :emenu_basket

    @order = Order.find_by(uuid: params[:uuid])
    rs = OrderService.new(@order).check_checkout_status

    if @order.stripe_data["payment_status"] == "paid"
      @receipt = @order.first_or_create_receipt
      flash[:notice] = "Payment successfully processed"
    else
      redirect_to resturant_path(@path), alert: "Payment Error: please try again"
    end  

  end

  private

  def stripe_parameters
    @parameters = params.slice(:service_type, :total, :price, :service_type, :collection_time, :date_offset, :table_number, :name, :telephone, :email, :house_number,
    :street, :postcode, :basket, :delivery_fee, :apple_and_google, :stripe_success_token, :group_order)
  end

  def get_restaurant
    @path = params[:id]
    @restaurant = Restaurant.where("lower(path) = ?", @path.downcase).first
  end

  def get_basket
    cookies.delete :emenu_basket if cookies['emenu_basket'].present? && @restaurant.id != JSON.parse(cookies['emenu_basket'])['key'].split('-').first.to_i
    @basket_service = BasketService.new(@restaurant, current_patron, cookies['emenu_basket'])
    cookies['emenu_basket'] = @basket_service.get_cookie
  end
end
