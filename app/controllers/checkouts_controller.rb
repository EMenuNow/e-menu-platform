class CheckoutsController < ApplicationController
  layout 'powered_by'
  before_action :get_restaurant
  before_action :get_basket
  before_action :stripe_parameters, only: [:index, :create, :pay, :stripe]
  skip_before_action :verify_authenticity_token, only: %i[stripe, create]

  def index
    checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)

    @delivery_time_options = @restaurant.available_times

    if @basket
      @basket_item_count = @basket_service.get_basket_item_count
      @basket_item_total = @basket_service.get_basket_item_total
    end
  end

  def create
    @checkout_service = CheckoutService.new(@restaurant, @parameters, @basket_service)

    render json: @checkout_service.create_checkout_session
  end
  
  def receipt
    cookies.delete :emenu_basket

    @order = Order.find_by(uuid: params[:uuid])
    rs = ReceiptService.new(@order).check_checkout_status

    if @order.stripe_data["payment_status"] == "paid"
      @receipt = @order.first_or_create_receipt
      flash[:notice] = "Payment successfully processed"
    else
      redirect_to resturant_path(@path), alert: "Payment Error: please try again"
    end  

  end

  private

  def stripe_parameters
    @parameters = params.slice(:service_type, :total, :price, :service_type, :collection_time, :table_number, :name, :telephone, :email, :house_number,
    :street, :postcode, :basket, :delivery_fee, :apple_and_google, :stripe_success_token)
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
