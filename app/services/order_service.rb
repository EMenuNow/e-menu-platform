class OrderService < ApplicationController

  def initialize(order)
    @order = order
    Stripe.api_key = @order.restaurant.stripe_sk_api_key
    @checkout_session = Stripe::Checkout::Session.retrieve(@order.stripe_data["id"])
  end

  def check_checkout_status
    @order.update_attribute(:stripe_data, @checkout_session)
  end

  def refund
    begin
      refund = Stripe::Refund.create({
        payment_intent: @order.stripe_data['payment_intent'],
        reverse_transfer: true
      })
      @order.refunds.create(stripe_data: refund)
      return true
    rescue Exception => e
      return e
    end
  end

end
