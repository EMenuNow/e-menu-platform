class OrdersController < ApplicationController

  def index
    @orders = Order.order(created_at: :DESC)
    # @orders = @orders.where(patrons: current_patron) if patron_signed_in?
    # @orders = @orders.all
  end

end
