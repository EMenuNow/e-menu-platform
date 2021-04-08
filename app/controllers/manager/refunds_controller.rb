module Manager
  class RefundsController < ApplicationController
    before_action :authenticate_manager_restaurant_user!

    def create
      @order = Order.includes(:receipts).where(:restaurant_id => params[:restaurant_id], :id => params[:id]).first
      os = nil
      @order.receipts.first.find_grouped_receipts.each do |e|
        logger.warn e.inspect
        os = OrderService.new(e.order).refund
      end
      if os == true
        redirect_to manager_live_orders_path(@order.restaurant), notice: "Success"
      else
        redirect_to manager_live_orders_path(@order.restaurant), notice: "Failure: #{os}"
      end
    end
  end
end
