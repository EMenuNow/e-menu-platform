# frozen_string_literal: true

module Onboarding
  class BaseController < ApplicationController
	  alias_method :current_user, :current_onboarding_restaurant_user # Could be :current_member or :logged_in_user

    layout 'onboarding'

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to onboarding_home_index_path, notice: exception.message 
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
      unless current_onboarding_restaurant_user.id == @restaurant.restaurant_user_id
        redirect_to '/422.html'
      end
    end
    
  end
end
