# frozen_string_literal: true

module Manager

class CustomListsController < Manager::BaseController
  before_action :authenticate_manager_restaurant_user!
  before_action :set_custom_list, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant

  # GET /custom_lists
  # GET /custom_lists.json
  def index
    @custom_lists = CustomList.where(restaurant_id: @restaurant.id)
  end

  # GET /custom_lists/1
  # GET /custom_lists/1.json
  def show
  end

  # GET /custom_lists/new
  def new
    @custom_list = CustomList.new
    @custom_list.restaurant_id = @restaurant.id
  end

  # GET /custom_lists/1/edit
  def edit
  end

  def up
    @restaurant = Restaurant.find(params[:restaurant_id])
    @custom_list = CustomList.find(params[:custom_list_id])
    @custom_list.move_higher
    @custom_list.save
    redirect_to manager_restaurant_custom_lists_path(@restaurant)
  end

  def down
    @restaurant = Restaurant.find(params[:restaurant_id])
    @custom_list = CustomList.find(params[:custom_list_id])
    @custom_list.move_lower
    @custom_list.save
    redirect_to manager_restaurant_custom_lists_path(@restaurant)
  end

  # POST /custom_lists
  # POST /custom_lists.json
  def create
    @custom_list = CustomList.new(custom_list_params)
    Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
    Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")

    respond_to do |format|
      if @custom_list.save
        format.html { redirect_to manager_restaurant_custom_list_path(@restaurant, @custom_list), notice: 'Option Set was successfully created.' }
        format.json { render :show, status: :created, location: @custom_list }
      else
        format.html { render :new }
        format.json { render json: @custom_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_lists/1
  # PATCH/PUT /custom_lists/1.json
  def update

    Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
    Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")
    
    Rails.cache.delete("custom_list_constraint_#{@custom_list.id}")
    Rails.cache.delete("custom_list_#{@custom_list.id}")
    Rails.cache.delete("custom_list_name_#{@custom_list.id}")
    
    respond_to do |format|
      if @custom_list.update(custom_list_params)
        format.html { redirect_to manager_restaurant_custom_list_path(@restaurant, @custom_list), notice: 'Option Set was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_list }
      else
        format.html { render :edit }
        format.json { render json: @custom_list.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /custom_lists/1
  # DELETE /custom_lists/1.json
  def destroy
    
    Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
    Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")
    
    Rails.cache.delete("custom_list_#{@custom_list.id}")
    Rails.cache.delete("custom_list_name_#{@custom_list.id}")

    @custom_list.destroy
    respond_to do |format|
      format.html { redirect_to manager_restaurant_custom_lists_path(@restaurant), notice: 'Option Set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_list
      @custom_list = CustomList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_list_params
      params.require(:custom_list).permit(:name, :restaurant_id, :constraint, :required_items, :limit_min, :limit_count, :limit_max)
    end
  end

end
