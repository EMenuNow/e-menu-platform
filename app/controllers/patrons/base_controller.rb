# frozen_string_literal: true

module Patrons
  class BaseController < ApplicationController
    DEFAULT_PATRON_PASSWORD = "defaultpassword".freeze

    layout 'application'
  end
end
