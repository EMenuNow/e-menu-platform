# frozen_string_literal: true

module Manager
  class LiveController < Manager::BaseController
    before_action :authenticate_manager_restaurant_user!, except: [:index]
    before_action :set_restaurant, except: [:send_receipt, :orders_broadcast]
    before_action :set_item_screens, except: [:send_receipt, :orders_broadcast]
    before_action :set_features, only: [:food, :drinks, :orders, :kitchen]
    before_action :set_printers, only: [:orders, :kitchen]
    
    before_action :live_params, only: [:food, :drinks, :orders, :kitchen]

    before_action :manager_data, only: [:orders]
    before_action :kitchen_data, only: [:kitchen, :food, :drinks]
    
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

    def kitchen_data
      if params[:date].present? and params[:start].present? and params[:end].present?
        start_date = (params[:start]).in_time_zone(@restaurant.time_zone)
        end_date = (params[:end]).in_time_zone(@restaurant.time_zone).end_of_day.in_time_zone(@restaurant.time_zone)
        @data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", start_date, end_date).includes(:screen_items, order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
      elsif params[:date].present? and params[:day].present?
        case params[:day]
        when "yesterday"
          day = Date.yesterday.in_time_zone(@restaurant.time_zone).all_day
          @data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(:screen_items, order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
        when "today"
          day = Date.today.in_time_zone(@restaurant.time_zone).all_day
          @data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(:screen_items, order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
        when "tomorrow"
          day = Date.tomorrow.in_time_zone(@restaurant.time_zone).all_day
          @data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(:screen_items, order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
        end
      end
      @data = Receipt.group_by_time(@restaurant.receipts.includes(:screen_items, order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date} unless @data
    end

    def manager_data
      if params[:date].present? and params[:start].present? and params[:end].present?
        start_date = (params[:start]).in_time_zone(@restaurant.time_zone)
        end_date = (params[:end]).in_time_zone(@restaurant.time_zone).end_of_day.in_time_zone(@restaurant.time_zone)
        first_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", start_date, end_date).includes(order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
        second_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: true).where("#{params[:date]} BETWEEN ? AND ?", start_date, end_date).includes(order: :refunds).order(id: :DESC)).reverse
      elsif params[:date].present? and params[:day].present?
        case params[:day]
        when "yesterday"
          day = Date.yesterday.in_time_zone(@restaurant.time_zone).all_day
          first_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
          second_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: true).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(order: :refunds).order(id: :DESC)).reverse
        when "today"
          day = Date.today.in_time_zone(@restaurant.time_zone).all_day
          first_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
          second_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: true).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(order: :refunds).order(id: :DESC)).reverse
        when "tomorrow"
          day = Date.tomorrow.in_time_zone(@restaurant.time_zone).all_day
          first_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date}
          second_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: true).where("#{params[:date]} BETWEEN ? AND ?", day.first, day.last).includes(order: :refunds).order(id: :DESC)).reverse
        end
      end

      first_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: false).includes(order: :refunds).order(id: :DESC)).sort_by{|x,y|y.first.due_date} unless first_search_data
      second_search_data = Receipt.group_by_time(@restaurant.receipts.where(is_ready: true).includes(order: :refunds).order(id: :DESC).limit(50)).reverse unless second_search_data
      
      @data = []
      @data += first_search_data
      @data += second_search_data
    end

    def live_params
      params.permit(:restaurant_id, :sort_by, :sort_order, :table_service, :collection, :delivery, :group_orders, :payment, :processing_status, :date, :start, :end, :day)
    end

  end
end
