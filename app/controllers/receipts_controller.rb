class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :set_live_receipt, only: [:queue_order, :send_to_kitchen, :preparing, :is_ready, :complete, :is_items_ready, :is_items_preparing]
  before_action :set_live_screen_item, only: [:is_item_ready, :is_item_process]
  skip_before_action :verify_authenticity_token, only: %i[create]
  # GET /receipts
  # GET /receipts.json
  def index
    @receipts = Receipt.all
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  def view_receipt
    @receipt = Receipt.find_by(uuid: params[:uuid])
    @restaurant = @receipt.restaurant
    @path = @restaurant.path
    respond_to do |format|
        format.html
        format.json 
    end
  end

  def queue_order
    if @receipt.group_order
      @receipts.each do |r|
        r.update(is_ready: false, processing_status: 'queued')
        r.screen_items.update_all(ready: false, processing_status: 'queued') if r.screen_items.any?
      end
    else
      @receipt.update(is_ready: false, processing_status: 'queued')
      @receipt.screen_items.update_all(ready: false, processing_status: 'queued') if @receipt.screen_items.any?
    end
    @restaurant = @receipt.restaurant
    @receipt.broadcast(message: "Queued")
    @receipt.broadcast_items
    # redirect_to manager_live_orders_path(@restaurant.id)
  end
  
  def send_to_kitchen
    if @receipt.group_order
      @receipts.each do |r|
        r.update(is_ready: false, processing_status: 'accepted')
        r.screen_items.update_all(ready: false, processing_status: 'accepted') if r.screen_items.any?
      end
    else
      @receipt.update(is_ready: false, processing_status: 'accepted')
      @receipt.screen_items.update_all(ready: false, processing_status: 'accepted') if @receipt.screen_items.any?
    end
    @restaurant = @receipt.restaurant
    @receipt.broadcast(message: "Accepted")
    @receipt.broadcast_items
    # redirect_to manager_live_orders_path(@restaurant.id)
  end
  
  def preparing
    if @receipt.group_order
      @receipts.each do |r|
        if r.processing_status == "preparing"
          r.update(is_ready: false, processing_status: 'accepted')
          r.screen_items.update_all(ready: false, processing_status: 'accepted') if r.screen_items.any?
        else
          r.update(is_ready: false, processing_status: 'preparing')
          r.screen_items.update_all(ready: false, processing_status: 'preparing') if r.screen_items.any?
        end
      end
    else
      if @receipt.processing_status == "preparing"
        @receipt.update(is_ready: false, processing_status: 'accepted')
        @receipt.screen_items.update_all(ready: false, processing_status: 'accepted') if @receipt.screen_items.any?
      else
        @receipt.update(is_ready: false, processing_status: 'preparing')
        @receipt.screen_items.update_all(ready: false, processing_status: 'preparing') if @receipt.screen_items.any?
      end
    end
    @restaurant = @receipt.restaurant
    @receipt.broadcast(message: "Preparing")
    @receipt.broadcast_items
    # redirect_to manager_live_orders_path(@restaurant.id)
  end
  
  def is_ready
    if @receipt.group_order
      @receipts.each do |r|
        r.update(is_ready: true, processing_status: 'ready')
        r.screen_items.update_all(ready: true, processing_status: 'ready') if r.screen_items.any?
      end
    else
      @receipt.update(is_ready: true, processing_status: 'ready')
      @receipt.screen_items.update_all(ready: true, processing_status: 'ready') if @receipt.screen_items.any?
    end
    @restaurant = @receipt.restaurant
    @receipt.broadcast(message: "Ready")
    @receipt.broadcast_items
    # redirect_to manager_live_orders_path(@restaurant.id)
  end
  
  def complete
    if @receipt.group_order
      @receipts.each do |r|
        r.update(is_ready: true, processing_status: 'complete')
        r.screen_items.update_all(ready: true, processing_status: 'complete') if r.screen_items.any?
      end
    else
      @receipt.update(is_ready: true, processing_status: 'complete')
      @receipt.screen_items.update_all(ready: true, processing_status: 'complete') if @receipt.screen_items.any?
    end
    @restaurant = @receipt.restaurant
    @receipt.broadcast(message: "Complete")
    @receipt.broadcast_items
    # redirect_to manager_live_orders_path(@restaurant.id)
  end
  
  def is_item_ready
    @screen_item.ready = !@screen_item.ready?
    @screen_item.save
    @restaurant = @receipt.restaurant
    path = manager_live_food_path(@restaurant) if @screen_item.item_screen_type_key == "FOOD"
    path = manager_live_drinks_path(@restaurant) if @screen_item.item_screen_type_key == "DRINK"
    
    @receipt.broadcast
    @receipt.broadcast_items
    # redirect_to path
  end
  
  def is_item_process # cycles screen item state
    if @screen_item.processing_status == "accepted"
      @screen_item.update(ready: false, processing_status: 'preparing')
    elsif @screen_item.processing_status == "preparing"
      @screen_item.update(ready: true, processing_status: 'ready')
    else
      @screen_item.update(ready: false, processing_status: 'accepted')
    end
    if @receipt.items_processing_status == "accepted"
      if @receipt.group_order
        @receipts.each do |r|
          r.update(is_ready: false, processing_status: 'accepted')
        end
      else
        @receipt.update(is_ready: false, processing_status: 'accepted')
      end
    elsif @receipt.items_processing_status == "ready"
      if @receipt.group_order
        @receipts.each do |r|
          r.update(is_ready: true, processing_status: 'ready')
        end
      else
        @receipt.update(is_ready: true, processing_status: 'ready')
      end
    else
      if @receipt.group_order
        @receipts.each do |r|
          r.update(is_ready: false, processing_status: 'preparing')
        end
      else
        @receipt.update(is_ready: false, processing_status: 'preparing')
      end
    end
    @restaurant = @receipt.restaurant
    path = manager_live_food_path(@restaurant) if @screen_item.item_screen_type_key == "FOOD"
    path = manager_live_drinks_path(@restaurant) if @screen_item.item_screen_type_key == "DRINK"
    
    @receipt.broadcast
    @receipt.broadcast_items
    # redirect_to path
  end
  
  def is_items_ready
    if @receipt.group_order
      @receipts.each do |r|
        r.screen_items.where(item_screen_type_key: params[:item_screen_type_key]).update_all(ready: true, processing_status: 'ready')
        if r.items_processing_status == "ready"
          r.update(is_ready: true, processing_status: 'ready')
        else
          r.update(is_ready: false, processing_status: 'preparing')
        end
      end
    else
      @receipt.screen_items.where(item_screen_type_key: params[:item_screen_type_key]).update_all(ready: true, processing_status: 'ready')
      if @receipt.items_processing_status == "ready"
        @receipt.update(is_ready: true, processing_status: 'ready')
      else
        @receipt.update(is_ready: false, processing_status: 'preparing')
      end
    end

    @restaurant = @receipt.restaurant
    path = manager_live_food_path(@restaurant) if params[:item_screen_type_key] == "FOOD"
    path = manager_live_drinks_path(@restaurant) if params[:item_screen_type_key] == "DRINK"
    
    @receipt.broadcast
    @receipt.broadcast_items
    # redirect_to path
  end
  
  def is_items_preparing
    if @receipt.items_processing_status(params[:item_screen_type_key]) != 'preparing'
      if @receipt.group_order
        @receipts.each do |r|
          r.screen_items.where(item_screen_type_key: params[:item_screen_type_key]).update_all(ready: false, processing_status: 'preparing')
          r.update(is_ready: false, processing_status: 'preparing')
        end
      else
        @receipt.screen_items.where(item_screen_type_key: params[:item_screen_type_key]).update_all(ready: false, processing_status: 'preparing')
        @receipt.update(is_ready: false, processing_status: 'preparing')
      end
    else
      if @receipt.group_order
        @receipts.each do |r|
          r.screen_items.where(item_screen_type_key: params[:item_screen_type_key]).update_all(ready: false, processing_status: 'accepted')
          r.update(is_ready: false, processing_status: 'accepted') if r.items_processing_status == "accepted"
        end
      else
        @receipt.screen_items.where(item_screen_type_key: params[:item_screen_type_key]).update_all(ready: false, processing_status: 'accepted')
        @receipt.update(is_ready: false, processing_status: 'accepted') if @receipt.items_processing_status == "accepted"
      end
    end
    @restaurant = @receipt.restaurant
    path = manager_live_food_path(@restaurant) if params[:item_screen_type_key] == "FOOD"
    path = manager_live_drinks_path(@restaurant) if params[:item_screen_type_key] == "DRINK"
  
    @receipt.broadcast
    @receipt.broadcast_items
    # redirect_to path
  end

  def item_creation_broadcast
    @receipt = Receipt.find(params[:receipt_id])
    @receipt.broadcast_items

    # redirect_to manager_live_orders_path(@receipt.restaurant_id)
  end


  def creation_broadcast
    @receipt = Receipt.find(params[:receipt_id])
    @receipt.creation_print

    redirect_to manager_live_orders_path(@receipt.restaurant_id)
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  def set_live_receipt
    @receipt = Receipt.find(params[:receipt_id])
    @receipts = @receipt.find_grouped_receipts if @receipt.group_order
  end
  
  def set_live_screen_item
    @screen_item = ScreenItem.find(params[:screen_item_id])
    @receipt = @screen_item.receipt
    @receipts = @receipt.find_grouped_receipts if @receipt.group_order
  end

  # Only allow a list of trusted parameters through.
  def receipt_params
    params.require(:receipt).permit(:uuid, :restaurant_id, :basket_total, :email, :stripe_token, :is_ready, :name, items: {}, status: {})
  end

end
