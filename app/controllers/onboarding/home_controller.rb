# frozen_string_literal: true

module Onboarding
  class HomeController < Onboarding::BaseController
    before_action :authenticate_onboarding_restaurant_user!, except: [:start]
    before_action :get_restaurant, except: [:start]
    before_action :get_onboarding
    before_action :get_features
    before_action :set_progress

    def start
      @restaurant = current_onboarding_restaurant_user.restaurant if current_onboarding_restaurant_user
      @progress[:register] += ' current'
    end
    
    def continue
      if @onboard&.completed
        redirect_to onboarding_restaurant_complete_path(@restaurant)
      elsif current_onboarding_restaurant_user.onboard&.tos_agreed? && @restaurant
        # @progress[:terms] = 'complete'
        # @progress[:restaurant] = 'complete'
        redirect_to edit_onboarding_restaurant_path(@restaurant)
      elsif current_onboarding_restaurant_user.onboard&.tos_agreed?
        # @progress[:terms] += 'complete'
        redirect_to new_onboarding_restaurant_path(@restaurant)
      elsif !current_onboarding_restaurant_user.onboard
        # @progress[:terms] += 'current'
        new_onboarding
      end
      @progress[:terms] += ' current'
    end
    
    def tos_agree
      respond_to do |format|
        if @onboard.update(onboard_params) && @restaurant
          tos_agreement
          format.html { redirect_to onboarding_restaurant_services_path(@restaurant), notice: 'Terms of service agreed.' }
          format.json { render :continue, status: :ok, location: @onboard }
        elsif @onboard.update(onboard_params)
          tos_agreement
          format.html { redirect_to new_onboarding_restaurant_path(@restaurant), notice: 'Terms of service agreed.' }
          format.json { render :continue, status: :ok, location: @onboard }
        else
          format.html { render :continue }
          format.json { render json: @onboard.errors, status: :unprocessable_entity }
        end
      end
    end
    
    private
    
    def get_restaurant
      @restaurant = current_onboarding_restaurant_user.restaurant
    end
    
    def get_onboarding
      @onboard = current_onboarding_restaurant_user.onboard if current_onboarding_restaurant_user&.onboard.present?
    end
    
    def new_onboarding
      @onboard = Onboard.new
      @onboard.update_attribute(:restaurant_user_id, current_onboarding_restaurant_user.id)
    end
    
    def tos_agreement
      @onboard.update_attribute(:tos_agreed_date, DateTime.now)
      @onboard.update_attribute(:tos_ip, request.ip)
      @onboard.update_attribute(:tos_user_agent, request.user_agent)
    end
        
    def get_features
      @features = Feature.all
      @services = Feature.find([12,9,11,10])
    end
    
    def set_progress
      @progress = {}
      @progress[:register] = current_onboarding_restaurant_user ? 'complete' : ''
      @progress[:terms] = current_onboarding_restaurant_user&.onboard&.tos_agreed? ? 'complete' : ''
      @progress[:restaurant] = current_onboarding_restaurant_user&.restaurant ? 'complete' : ''
      @progress[:services] = (current_onboarding_restaurant_user&.restaurant && (current_onboarding_restaurant_user.restaurant.features & Feature.find([12,9,11,10])).any?) ? 'complete' : ''
      @progress[:connect] = @onboard&.completed ? 'complete' : @onboard&.completed.nil? ? '' : 'failed'
    end

    def onboard_params
      params.require(:onboard).permit(:tos_agreed, :tos_agreed_date, :tos_ver_agreed, :tos_ip, :tos_user_agent, :free_trial, :completed)
    end

  end
end
