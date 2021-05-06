# frozen_string_literal: true

module Manager
  class LiveController < Manager::BaseController
    before_action :authenticate_manager_restaurant_user!, except: [:index]
    before_action :set_restaurant, except: [:send_receipt, :orders_broadcast]
    before_action :set_item_screens, except: [:send_receipt, :orders_broadcast]
    before_action :set_features, only: [:food, :drinks, :orders, :kitchen]
    before_action :set_printers, only: [:orders, :kitchen]
    
    layout :layout_chooser

    def layout_chooser
      if ['kitchen','food','drinks','orders'].include?(params[:action])
        'live_screen_manager'
      end
    end

    def tables
      @restaurant_tables = RestaurantTable.where(restaurant_id: @restaurant.id).order(:number)
    end

    def items
      @restaurant_tables = RestaurantTable.where(restaurant_id: @restaurant.id).order(:number)
    end

    def order
    end

    def kitchen
    end

    def orders
    end

    def food
      item_screens = ItemScreen.where(restaurant_id: @restaurant.id).joins(:item_screen_type).where("item_screen_types.key = 'FOOD'")
      @item_screen = item_screens.first if item_screens.present?
      @printers = Printer.where(restaurant_id: @restaurant.id)
    end

    def drinks
      item_screens = ItemScreen.where(restaurant_id: @restaurant.id).joins(:item_screen_type).where("item_screen_types.key = 'DRINK'")
      @item_screen = item_screens.first if item_screens.present?
      @printers = Printer.where(restaurant_id: @restaurant.id)
    end

    def service
      @table_item = TableItem.find(params[:table_item_id])
      @table_item.service
      @table_item.save
      respond_to do |format|
          format.html { redirect_to manager_live_items_path(@restaurant.id), notice: 'Item successfully moved to service.' }
      end
    end

    def ready
      @table_item = TableItem.find(params[:table_item_id])
      @table_item.finish!
      respond_to do |format|
        format.html { redirect_to manager_live_items_path(@restaurant.id), notice: 'Item successfully finished.' }
      end
    end

    def send_receipt
      @receipt = Receipt.find(params[:receipt_id])
      receipts = @receipt.find_grouped_receipts
      receipts.each do |r|
        r.email_receipt if r.email.present?
      end
      respond_to do |format|
        format.html { redirect_to manager_live_orders_path(@receipt.restaurant.id), notice: 'Receipt Sent.' }
      end
    end

    def receipts
      @printers = Printer.where(restaurant_id: @restaurant.id)
      @restaurant = Restaurant.find(params[:restaurant_id])
      @receipts = @restaurant.receipts.page params[:page]
    end

    def orders_broadcast
      Receipt.last.broadcast
    end

    private

    def set_item_screens
      @item_screens = ItemScreen.where(restaurant_id: @restaurant.id)
    end

    def set_features
      @features = Feature.all
      @services = Feature.find([12,9,11,10])
    end

    def set_printers
      @printers = Printer.where(restaurant_id: @restaurant.id)
    end

    def live_params
      params.permit(:sort_by, :sort_order, :table_service, :collection, :delivery, :group_orders, :payment, :processing_status)
    end

  end
end
