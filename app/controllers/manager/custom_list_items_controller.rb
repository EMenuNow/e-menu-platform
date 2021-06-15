# frozen_string_literal: true

module Manager

class CustomListItemsController < Manager::BaseController
  before_action :authenticate_manager_restaurant_user!
  before_action :set_custom_list_item, only: [:show, :edit, :update, :destroy]
  before_action :set_spice_levels, only: %i[new create edit update]
  before_action :set_menu_item_categorisations, only: %i[new create edit update]
  before_action :set_restaurant
  before_action :set_custom_list
  
  # GET /custom_list_items
  # GET /custom_list_items.json
  def index
    @custom_list_items = CustomListItem.all
  end

  # GET /custom_list_items/1
  # GET /custom_list_items/1.json
  def show
  end

  # GET /custom_list_items/new
  def new
    @custom_list_item = CustomListItem.new
  end

  # GET /custom_list_items/1/edit
  def edit
  end

  # POST /custom_list_items
  # POST /custom_list_items.json
  def create
    @custom_list_item = CustomListItem.new(custom_list_item_params)

    respond_to do |format|
      if @custom_list_item.save

        @allergens.each{|a| ([params[:contains_allergen_ids], params[:may_contain_allergen_ids]].compact.reduce([], :|)).include?(a.id.to_s) ? CategorisationsCli.where(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: a.id).first_or_create.update(contains: params[:contains_allergen_ids]&.include?(a.id.to_s), may_contain: params[:may_contain_allergen_ids]&.include?(a.id.to_s), dietary: nil, category: nil) : CategorisationsCli.find_by(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: a.id)&.destroy}
        @diets.each{|d| params[:dietary_ids]&.include?(d.id.to_s) ? CategorisationsCli.where(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: d.id).first_or_create.update(dietary: true, contains: nil, may_contain: nil, category: nil) : CategorisationsCli.find_by(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: d.id)&.destroy}
        @categories.each{|c| params[:menu_item_categorisation_ids]&.include?(c.id.to_s) ? CategorisationsCli.where(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: c.id).first_or_create.update(dietary: nil, contains: nil, may_contain: nil, category: true) : CategorisationsCli.find_by(custom_list_item_id: @menu.id, menu_item_categorisation_id: c.id)&.destroy}

        format.html { redirect_to manager_restaurant_custom_list_path(@restaurant, @custom_list), notice: 'Option Set item was successfully created.' }
        format.json { render :show, status: :created, location: @custom_list_item }
      else
        format.html { render :new }
        format.json { render json: @custom_list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_list_items/1
  # PATCH/PUT /custom_list_items/1.json
  def update
    
    Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
    Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")

    Rails.cache.delete("custom_list_item_#{@custom_list_item.id}")
    Rails.cache.delete_matched("custom_list_items*-#{@custom_list_item.id}-*")
    Rails.cache.delete("custom_list_#{@custom_list.id}")
    
    respond_to do |format|
      if @custom_list_item.update(custom_list_item_params)

        @allergens.each{|a| ([params[:contains_allergen_ids], params[:may_contain_allergen_ids]].compact.reduce([], :|)).include?(a.id.to_s) ? CategorisationsCli.where(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: a.id).first_or_create.update(contains: params[:contains_allergen_ids]&.include?(a.id.to_s), may_contain: params[:may_contain_allergen_ids]&.include?(a.id.to_s), dietary: nil, category: nil) : CategorisationsCli.find_by(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: a.id)&.destroy}
        @diets.each{|d| params[:dietary_ids]&.include?(d.id.to_s) ? CategorisationsCli.where(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: d.id).first_or_create.update(dietary: true, contains: nil, may_contain: nil, category: nil) : CategorisationsCli.find_by(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: d.id)&.destroy}
        @categories.each{|c| params[:menu_item_categorisation_ids]&.include?(c.id.to_s) ? CategorisationsCli.where(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: c.id).first_or_create.update(dietary: nil, contains: nil, may_contain: nil, category: true) : CategorisationsCli.find_by(custom_list_item_id: @custom_list_item.id, menu_item_categorisation_id: c.id)&.destroy}

        format.html { redirect_to manager_restaurant_custom_list_path(@restaurant, @custom_list), notice: 'Option Set item was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_list_item }
      else
        format.html { render :edit }
        format.json { render json: @custom_list_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /custom_list_items/1
  # DELETE /custom_list_items/1.json
  def destroy
    
    Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
    Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")
    
    Rails.cache.delete("custom_list_item_#{@custom_list_item.id}")
    Rails.cache.delete("custom_list_#{@custom_list.id}")

    clear_list_item(@custom_list.id, @custom_list_item.id)
    @custom_list_item.destroy
    respond_to do |format|
      format.html { redirect_to manager_restaurant_custom_list_path(@restaurant, @custom_list), notice: 'Option Set item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_active
    @custom_list_item = CustomListItem.find(params[:custom_list_item_id])

    Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
    Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")

    Rails.cache.delete("custom_list_item_#{@custom_list_item.id}")
    Rails.cache.delete_matched("custom_list_items*-#{@custom_list_item.id}-*")
    Rails.cache.delete("custom_list_#{@custom_list.id}")

    @custom_list_item.available = !@custom_list_item.available
    @custom_list_item.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_list_item
      @custom_list_item = CustomListItem.find(params[:id])
    end

    def set_custom_list
      @custom_list = CustomList.find(params[:custom_list_id])
    end

    def set_spice_levels
      @spice_levels = SpiceLevel.all
    end

    def set_menu_item_categorisations
      @menu_item_categorisations = MenuItemCategorisation.all
      @allergens = Allergen.all.sort_by &:id
      @diets = Dietary.all.sort_by &:id
      @categories = Category.all.sort_by &:id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_list_item_params
      params.require(:custom_list_item).permit(:name, :custom_list_id, :custom_list_item_id, :price, :description, :available, :spice_level_id, menu_item_categorisation_ids: [], contains_allergen_ids: [], may_contain_allergen_ids: [])
    end

    def clear_list_item(list_id, list_item_id)
      query = Menu.where("custom_lists -> '#{list_id}' ? '#{list_item_id}'")
      query.each do |h|
        h.custom_lists["#{list_id}"].delete("#{list_item_id}")
        h.custom_lists.delete("#{list_id}") if h.custom_lists["#{list_id}"].length == 0
        h.save
      end
    end

  end

end
