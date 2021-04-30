# frozen_string_literal: true

module Patrons
  class PatronAllergensController < ApplicationController
    before_action :authenticate_patron!
    # layout 'order'


    # remote: true
    def update
      patron_allergen = current_patron.patron_allergens.where(:menu_item_categorisation_id => params[:id]).first_or_initialize
      patron_allergen.active = params[:active]
      
      if patron_allergen.save
        head :ok
      else
        render :json => patron_allergens.errors, :status => :unprocessable_entity
      end   
    end
  end
end
