class CheckoutService < ApplicationController

  def initialize(restaurant, parameters, basket_service)
    parameters.each_pair {|k,v|instance_variable_set("@#{k}", v)}
    @restaurant = restaurant
    @basket_service = basket_service

    @total_payment = @total.to_f 
    @payment_in_pence = (@total_payment*100).to_i
    @address = "#{@house_number}, #{@street}, #{@postcode}"
  end

  def create_transaction
    Stripe.api_key = @restaurant.stripe_sk_api_key
    Stripe::PaymentIntent.create({
      amount: @payment_in_pence,
      currency: 'gbp',
      payment_method_types: ['card'],
      description: "#{@path} charge"  
    })
  end

  def make_payment

  end

  def generate_receipt
    if @stripe_success_token.present?
      if @apple_and_google.present?
        @stripe_payment_intent = @stripe_success_token
      else
        @stripe_payment_intent = JSON.parse(@stripe_success_token)
      end

      if @stripe_payment_intent['status'] == 'succeeded'
        success = true
        stripe_token = @stripe_payment_intent['id']
        stripe_data = @stripe_payment_intent
      end 
    end

    Receipt.create(
      uuid: SecureRandom.uuid,
      restaurant_id: @restaurant.id,
      basket_total: @price.to_i,
      items: @basket_service.basket_build(@basket_service.get_basket_db.contents['ids']),
      email: @email,
      name: @name,
      collection_time: @collection_time,
      stripe_token: stripe_token || {},
      status: stripe_data || {},
      is_ready: false,
      source: :takeaway, 
      telephone: @telephone,
      address: @address,
      delivery_or_collection: @service_type,
      delivery_fee: @delivery_fee, 
      table_number: @table_number
    )
  end

end
