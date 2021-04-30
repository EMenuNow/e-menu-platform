# frozen_string_literal: true

module Patrons
  class PatronAddressesController < ApplicationController
    before_action :authenticate_patron!

    # remote: true
    def update
      patron_addresses = current_patron.patron_addresses.where(:address_id => params[:id]).first_or_initialize
      
      if patron_addresses.save
        head :ok
      else
        render :json => patron_addresses.errors, :status => :unprocessable_entity
      end
    end

    private

    def patron_addresses_params
      params.require(:patron_addresses).permit(:emenu_news, :enenu_promotions, :restaurant_news, :restaurant_promotions)
    end
  end
end
