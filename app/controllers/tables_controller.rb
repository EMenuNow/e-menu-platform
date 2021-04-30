# frozen_string_literal: true

class TablesController < ApplicationController
  before_action :set_table, only: %i[ show edit update destroy]
  before_action :authenticate_manager_restaurant_user!, except: %i[sectioned_menus show pay stripe finish add_item]
  skip_before_action :verify_authenticity_token, only: %i[pay stripe]
  # GET /tables
  # GET /tables.json
  def index
    @tables = Table.all
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    table_id = cookies[:table_id]
    @price = @table.table_items.reject{|a| a.paid?}.map{|e| e.total_price}.inject(:+) || 0
    @restaurant = @table.restaurant
    @template = @restaurant.template.first&.key || Template.first.key
    
    @menu_id = params[:menu_id].to_i if params[:menu_id].present?



    redirect_to home_index_path, alert: t('register_table.error.expired') unless @table.id == table_id.to_i
  end
  # def sectioned_menus
  #   @menu_id = params[:menu_id].to_i if params[:menu_id].present?
  #   table_id = cookies[:table_id]
  #   @table = Table.find(table_id)
  #   @price = @table.table_items.reject{|a| a.paid?}.map{|e| e.total_price}.inject(:+) || 0
  #   @restaurant = @table.restaurant
  #   # binding.pry
  #   @template = @restaurant.template.first.key 
  #   redirect_to home_index_path, alert: t('register_table.error.expired') unless @table.id == table_id.to_i
  # end

  # GET /tables/new
  def new
    @table = Table.new
  end

  # GET /tables/1/edit
  def edit; end

  def add_item

    # binding.pry

    @table = Table.find(params[:table_id])
    @menu = Menu.find(params[:menu_id])
    for_person = params[:for]
    custom_lists = {}
    if params[:table]
      custom_lists = params[:table][:custom_lists] || {}
    end

    @table_item = TableItem.new(
      table_id: @table.id,
      menu_id: @menu.id,
      for: for_person,
      custom_lists: custom_lists
    )
    @table_item.order

   
  # binding.pry

    respond_to do |format|
      if @table_item.save
        
        # format.html { redirect_to table_path(@table), notice: "#{@menu.name} was added to your order successfully." }
        format.js
      else
        # format.html { redirect_to table_path(@table), alert: "Please choose option: #{@table_item.errors.map{|k,v| k.to_s.capitalize}.join(", ")}" }
        format.js
      end
    end
  end

  def pay
    @table = Table.find(params[:table_id])
    @publish_stripe_api_key = @table.restaurant.stripe_pk_api_key
  end

  def stripe
    error = nil
    status = nil
    
    @table = Table.find(params[:table_id])
    @restaurant = @table.restaurant

    Stripe.api_key = @restaurant.stripe_sk_api_key

    token = params[:token]
    price = params[:price].to_i

    Rails.logger.debug("Payment Token: #{token}")
    Rails.logger.debug("Payment Price: #{price}")

    begin
      status = Stripe::Charge.create(
        amount: price,
        currency: @restaurant.currency_code,
        description: '#{@restaurant.name} charge',
        source: token
      )
      table_items = TableItem.where(id: params[:items].split(','))
      # table_items.update_all(paid: true, token: token)
      table_items.each do |item|
        item.paid
        item.token = token
        item.save
      end
      # binding.pry

    rescue Exception => e
      error = e
    end

    # respond_to do |format|
    #   if error.present?
    #     format.json { render json: { error: 'true', url: table_pay_path(@table), message: "#{t('payment.error')}: #{e.message}" } }
    #     format.html { redirect_to table_pay_path(@table), alert: "#{t('payment.error')}: #{e.message}" }
    #   else
    #     format.json { render json: { error: 'false', url: table_pay_path(@table), message: t('payment.success') } }
    #     format.html { redirect_to table_pay_path(@table), notice: t('payment.success') }
    #   end
    # end

      if error.present?
        redirect_to table_pay_path(@table), alert: "#{t('payment.error')}: #{e.message}" 
      else
        items = table_items.map{|a| {item: a.menu.name, total: a.price_a, optionals: custom_item_list(a)}}

        @receipt =  Receipt.create(
          uuid: SecureRandom.uuid,
          restaurant_id: @restaurant.id,
          basket_total: price,
          items: {items: items, count: items.count, restaturant: @restaurant.name},
          #email: '',
          name: '',
          collection_time: Time.now,
          stripe_token: token,
          status: status,
          is_ready: false,
          source: :dinein, 
          telephone: '',
          address: '',
          delivery_or_collection: ''
        )
    

        # {
        #   "ids": 
        #   [
        #     {"item": 154, "uuid": "2249aafe-50d1-4edb-80b5-17d35c74f3eb", "total": 3.95, "optionals": [155]}, 
        #     {"item": 151, "uuid": "af87feac-7e3a-4304-8243-b98c49104251", "total": 1.25, "optionals": []}
        #   ], 
        #   "count": 2, 
        #   "items": 
        #     [
        #       {"item": "<i>The Sweet Stuff</i> - <strong>Churros</strong>", "uuid": "2249aafe-50d1-4edb-80b5-17d35c74f3eb", "total": 3.95, "optionals": ["<i>Sweet Sauce & Toppings</i> - <strong>Vanilla Sugar</strong>"]}, 
        #       {"item": "<i>Cold Drinks</i> - <strong>Still Water</strong>", "uuid": "af87feac-7e3a-4304-8243-b98c49104251", "total": 1.25, "optionals": []}
        #     ], 
        #   "restaurant": "thesauce"
        # }
        
        
        
        
        
        # [
        #   {"name": "HALLOUMI BITES", "price": "3.95", "custom_items": []}, 
        #   {"name": "CHILLI FRIED CHICKEN BITES", "price": "4.65", "custom_items": []}
        # ]



        puts "************************************************************************"
        puts 'RECEIPT TO BE CREATED AT'
        puts "************************************************************************"
        redirect_to table_pay_path(@table, receipt_uuid: @receipt.uuid), notice: t('payment.success') 
      end
  end

  def custom_item_list(item)
    ret = []
    item.custom_lists.keys.each do |list_id|
      custom_list = CustomList.find(list_id)
        item.custom_lists[list_id].each do |list_item_id|
          list_item = CustomListItem.find(list_item_id)
          # ret << {list_name: custom_list.name, item_name: list_item.name, price: list_item.price }
          ret << "<i>#{custom_list.name}</i> - <strong>#{list_item.name}</strong>"
        end
    end
    ret
  end



  def finish
    @table = Table.find(params[:table_id])
    price = @table.current_total

    respond_to do |format|
      if price.zero?
        @table.finish
        @table.save
        format.html { redirect_to root_path(@table), notice: t('table.close.success') }
      else
        format.html { redirect_to table_pay_path(@table), notice: t('table.close.error') }
      end
    end
  end


  def manager_finish
    @table = Table.find(params[:table_id])
    price = @table.current_total

    respond_to do |format|
      if price.zero?
        @table.finish
        @table.save
        format.html { redirect_to manager_live_tables_path(@table.restaurant), notice: t('table.close.success') }
      else
        format.html { redirect_to manager_live_tables_path(@table.restaurant), notice: t('table.close.error') }
      end
    end
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(table_params)

    respond_to do |format|
      if @table.save
        format.html { redirect_to @table, notice: 'Table was successfully created.' }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to @table, notice: 'Table was successfully updated.' }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table.destroy
    respond_to do |format|
      format.html { redirect_to tables_url, notice: 'Table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_table
    @table = Table.find(params[:id]) if params[:id].present?    
    @table = Table.find(params[:table_id]) if params[:table_id].present? 
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def table_params
    params.require(:table).permit(:restaurant_table_id, :password, :aasm_state, :custom_lists)
  end
end
