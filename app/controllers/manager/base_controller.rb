# frozen_string_literal: true

module Manager
  class BaseController < ApplicationController
	  alias_method :current_user, :current_manager_restaurant_user # Could be :current_member or :logged_in_user

    layout 'manager'

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to manager_home_index_path, notice: exception.message 
    end


    def set_restaurant
      @restaurant = Restaurant.where(id: params[:restaurant_id]).first || current_manager_restaurant_user.restaurant
      unless current_manager_restaurant_user.id == @restaurant.restaurant_user_id
        redirect_to '/422.html'
      end
    end

    def authenticate_admin!
      current_user.admin ? true : (redirect_to manager_home_index_path, :notice => "Admin level required")
    end
  end

end



