# frozen_string_literal: true

module Patrons
  class PatronMarketingPreferencesController < ApplicationController
    before_action :authenticate_patron!

    # remote: true
    def update
      patron_marketing_preference = current_patron.patron_marketing_preference
      if patron_marketing_preference.update(patron_marketing_preference_params)
        head :ok
      else
        render :json => patron_marketing_preference.errors, :status => :unprocessable_entity
      end   
    end

    private

    def patron_marketing_preference_params
      params.require(:patron_marketing_preference).permit(:emenu_news, :enenu_promotions, :restaurant_news, :restaurant_promotions)
    end
  end
end
