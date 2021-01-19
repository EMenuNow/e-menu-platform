class CheckoutsController < ApplicationController
  layout 'powered_by'
  before_action :get_restaurant
  before_action :get_basket
  before_action :stripe_parameters, only: [:index, :pay, :stripe]
  skip_before_action :verify_authenticity_token, only: %i[stripe]

  def index
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
        format.html { redirect_to checkouts_path(@path), alert: "Payment Error: #{e.message}" } 
        format.json { render json: {ok: true, error: true, path: receipt_path(@path, @receipt.uuid)} }
      else
        format.html { redirect_to receipt_path(@path, @receipt.uuid), notice: "Payment Successful" }
        format.json { render json: {ok: true, error: false, path: receipt_path(@path, @receipt.uuid)} }
      end
    end   
  end  
  
  def receipt
    @uuid = params[:uuid]
    @receipt = Receipt.find_by(uuid: @uuid)
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
