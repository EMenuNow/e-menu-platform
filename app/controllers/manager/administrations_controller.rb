# frozen_string_literal: true

module Manager
  class AdministrationsController < Manager::BaseController
    before_action :authenticate_manager_restaurant_user!
    before_action :authenticate_admin!

    def index
      @restaurants = Restaurant.includes(:restaurant_user).all
    end

    def login_as
      @restaurant_user = RestaurantUser.find(params[:id])
      sign_in(@restaurant_user)
      redirect_to root_path, notice: "Force signed in successfully"
    end

    private

  end
end
