# frozen_string_literal: true

module Onboarding
  class RestaurantsController < Onboarding::BaseController
    before_action :authenticate_onboarding_restaurant_user!

    before_action :set_restaurant_new, only: %i[edit update services connect complete]
    before_action :set_cuisine, only: %i[new create edit update]
    before_action :get_onboarding
    before_action :set_progress

    before_action :set_features, only: %i[services connect complete]

    # GET /restaurants/new
    def new
      @restaurant = Restaurant.new
      @restaurant.restaurant_user_id = current_onboarding_restaurant_user.id
      @progress[:restaurant] += ' current'
    end
    
    # POST /restaurants
    # POST /restaurants.json
    def create
      @restaurant = Restaurant.new(restaurant_params)
      
      respond_to do |format|
        if @restaurant.save
          format.html { redirect_to onboarding_restaurant_services_path(@restaurant), notice: 'Business was successfully created.' }
          format.json { render :show, status: :created, location: @restaurant }
        else
          format.html { render :new }
          format.json { render json: @restaurant.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def edit
      @progress[:restaurant] += ' current'
    end
    
    def update
      respond_to do |format|
        if @restaurant.update(restaurant_params)
          format.html { redirect_to onboarding_restaurant_services_path(@restaurant), notice: 'Business was successfully updated.' }
          format.json { render :show, status: :ok, location: @restaurant }
        else
          format.html { render :edit }
          format.json { render json: @restaurant.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def services
      @progress[:services] += ' current'
    end
    
    def toggle_feature
      @restaurant = Restaurant.find(params[:restaurant_id])
      feature = Feature.find(params[:feature_id])
      if @restaurant.features.include?(feature)
        @restaurant.features.delete(feature)
      else
        @restaurant.features << feature
      end
    end
    
    def connect
      @progress[:connect] += ' current'
            
      connect_service = ConnectService.new(@restaurant)
      if session[:account_id]
        @restaurant.update_attribute(:stripe_connected_account_id, session[:account_id])
        @connect = connect_service.refresh_account(session[:account_id])
      elsif @restaurant.stripe_connected_account_id
        @connect = connect_service.refresh_account(@restaurant.stripe_connected_account_id)
      else
        create_account = connect_service.create_account
        session[:account_id] = create_account[:account_id]
        @restaurant.update_attribute(:stripe_connected_account_id, create_account[:account_id])
        @connect = create_account[:url]
      end
    end
    
    def complete
      connect_service = ConnectService.new(@restaurant)
      @account = connect_service.get_account
      @connect = connect_service.refresh_account(@restaurant.stripe_connected_account_id) if !@account[:details_submitted]
      @onboard.update_attribute(:free_trial, true) if @account[:details_submitted] # stripe onboarding details submitted
      EmenuMailer.welcome(@restaurant.id, @connect).deliver_now if @onboard&.completed.nil?
      @account[:details_submitted] ? @onboard.update_attribute(:completed, true) : @onboard.update_attribute(:completed, false) # stripe onboarding details submitted
      @progress[:connect] = @account[:details_submitted] ? 'complete' : 'failed'
    end

    def dashboard_login
      @restaurant_user = RestaurantUser.find(params[:restaurant_user_id])
      @restaurant_user.reload
      sign_in(@restaurant_user)
      redirect_to manager_home_index_path
    end
    
    private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant_new
      @restaurant = Restaurant.find(params[:restaurant_id] || params[:id])
      unless current_onboarding_restaurant_user.id == @restaurant.restaurant_user_id
        raise NotValidRestaurant
      end
    end
    
    def get_onboarding
      @onboard = current_onboarding_restaurant_user.onboard
    end
    
    def set_progress
      @progress = {}
      @progress[:register] = current_onboarding_restaurant_user ? 'complete' : ''
      @progress[:terms] = @onboard&.tos_agreed ? 'complete' : ''
      @progress[:restaurant] = current_onboarding_restaurant_user.restaurant ? 'complete' : ''
      @progress[:services] = (current_onboarding_restaurant_user&.restaurant && (current_onboarding_restaurant_user.restaurant.features & Feature.find([12,9,11,10])).any?) ? 'complete' : ''
      @progress[:connect] = @onboard&.completed ? 'complete' : @onboard&.completed.nil? ? '' : 'failed'
    end
    
    def set_cuisine
      @cuisines = Cuisine.all
    end
    
    def set_features
      @features = Feature.all
      @services = Feature.find([12,9,11,10])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :address, :postcode, :telephone, :email, :twitter, :facebook, :opening_times, :is_chain, :cuisine_id, :image, :restaurant_user_id, :slug, :path, :css_font_url, :css_font_class, :custom_css, :custom_styles, :url, :stripe_api_key, :stripe_publish_api_key, :stripe_connected_account_id, :commision_percentage, :delay_time_minutes, :show_on_homepage, :facebook_pixel, :background_image, :subtle_background, :currency_id)
    end

  end
end
