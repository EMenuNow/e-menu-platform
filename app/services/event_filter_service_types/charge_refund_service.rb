class ChargeRefundService
  def initialize(payload)
    @data = payload[:data][:object]
    @refunds = @data[:refunds][:data]
    @refund_amount = @refunds[0][:amount]
    @restaurant = Restaurant.where(stripe_connected_account_id: payload[:account]).first
    Stripe.api_key = @restaurant.stripe_sk_api_key
    lookup_order
    issue_refund
  end
  
  private
  
  def lookup_order
    @transfer = Stripe::Transfer.retrieve(@data[:source_transfer])
    @charge = Stripe::Charge.retrieve(@transfer[:source_transaction])
    @order = Order.where("stripe_data ->> 'payment_intent' = ?", @charge[:payment_intent]).first
  end

  def issue_refund
    OrderService.new(@order).refund(@refund_amount, false)
  end
end