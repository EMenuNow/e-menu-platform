# frozen_string_literal: true

module Manager
  class MenusController < Manager::BaseController
    before_action :authenticate_manager_restaurant_user!
    before_action :set_spice_levels, only: %i[new create edit update]
    before_action :set_cook_levels, only: %i[new create edit update]
    before_action :set_menu_item_categorisations, only: %i[new create edit update]
    before_action :set_menu, only: %i[show edit update destroy]
    before_action :set_restaurant

    # GET /menus
    # GET /menus.json
    def index
      @menus = Menu.where(restaurant_id: @restaurant, ancestry: nil)
      @sorted_menus = Menu.sort_by_ancestry(@menus)
      @updated_menu = params[:updated_menu].to_i if params[:updated_menu]
    end






    # GET /menus/1
    # GET /menus/1.json
    def show; end

    # GET /menus/new
    def new
      @menu = Menu.new
      @menu.restaurant = @restaurant
      @menu.node_type = params[:node_type]
    end

    # GET /menus/1/edit
    def edit; end

    # POST /menus
    # POST /menus.json
    def create
      @menu = Menu.new(menu_params)
      # binding.pry
      @menu.parent = Menu.find(params[:parent]) if params[:parent].present?
      Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
      Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")
  
      respond_to do |format|
        if @menu.save

          if @menu.node_type == 'menu'
            @menu.root_node_id = @menu.id
            @menu.save
          end

          @menu.translate
          redirect_location = @menu.node_type == 'item' ? manager_restaurant_menu_path(@restaurant, @menu, updated_menu: @menu.id) : manager_restaurant_menus_path(@restaurant, updated_menu: @menu.id)
          format.html { redirect_to redirect_location, notice: 'Menu was successfully created.' }
          format.json { render :show, status: :created, location: @menu }
        else
          format.html { render :new }
          format.json { render json: @menu.errors, status: :unprocessable_entity }
        end
      end
    end


    def clone
      @menu = Menu.find(params[:menu_id])
      @new_menu = @menu.dup
      @new_menu.name = "#{@new_menu.name} [CLONE]"
      respond_to do |format|
        if @new_menu.save
          @new_menu.translate
          redirect_location = @new_menu.node_type == 'item' ? manager_restaurant_menu_path(@restaurant, @new_menu, updated_menu: @new_menu.id) : manager_restaurant_menus_path(@restaurant, updated_menu: @new_menu.id)
          format.html { redirect_to redirect_location, notice: 'Menu was successfully created.' }
          format.json { render :show, status: :created, location: @menu }
        else
          format.html { render :new }
          format.json { render json: @menu.errors, status: :unprocessable_entity }
        end
      end
    end


    # PATCH/PUT /menus/1
    # PATCH/PUT /menus/1.json
    def update

      Rails.cache.delete("api/restaurant/#{@restaurant.id}/menu")
      Rails.cache.delete("restaurant_order_menu_#{@restaurant.id}")
  
      respond_to do |format|
        if @menu.update(menu_params)

          if params[:menu][:custom_lists].blank?
            @menu.custom_lists = {}
            @menu.save
          end

          @menu.translate

          is_index =  params[:index] == 'true'



          redirect_location = @menu.node_type == 'item' ? manager_restaurant_menu_path(@restaurant, @menu, updated_menu: @menu.id) : manager_restaurant_menus_path(@restaurant, updated_menu: @menu.id)
          redirect_location = manager_restaurant_menus_path(@restaurant, updated_menu: @menu.id) if is_index 

          format.html { redirect_to redirect_location, notice: 'Menu was successfully updated.' }
          format.json { render :show, status: :ok, location: @menu }
        else
          format.html { render :edit }
          format.json { render json: @menu.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /menus/1
    # DELETE /menus/1.json
    def destroy
      parent_id = @menu.parent.present? ? @menu.parent.id : nil
      @menu.is_deleted = true
      Menu.where(id: @menu.descendant_ids).update_all(is_deleted: true)
      @menu.save
      respond_to do |format|
        format.html { redirect_to manager_restaurant_menus_path(@restaurant, updated_menu: parent_id), notice: 'Menu was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.

    def set_menu
      @menu = Menu.find(params[:id])
    end



    def set_spice_levels
      @spice_levels = SpiceLevel.all
    end
    def set_cook_levels
      @cook_levels = CookLevel.all
    end

    def set_menu_item_categorisations
      @menu_item_categorisations = MenuItemCategorisation.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:restaurant_id, :nutrition, :provenance, :name, :description, :image, :spice_level_id, :node_type, :prices, :available, :calories, :position, :price_a, :price_b, :css_class, :item_screen_type_id, menu_item_categorisation_ids: [], custom_lists: {} )
    end
  end
end
