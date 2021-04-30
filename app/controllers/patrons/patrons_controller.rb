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
    end
  end
end
