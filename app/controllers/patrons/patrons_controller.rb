# frozen_string_literal: true

module Patrons
  class PatronsController < ApplicationController
    before_action :authenticate_patron!
    # layout 'order'

    def index
      @patrons = Patron.all
    end

    def show
      @patron = current_patron
      @allergens = Allergen.all.sort_by &:id
      @diets = Dietary.all.sort_by &:id
      @categories = Category.all.sort_by &:id
    end
  end
end
