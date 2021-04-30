# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :choose_locale
  before_action :set_languages
  before_action :route_domain

  def route_domain
    @domain = request.subdomain
    @path = request.path
    if @path == '/'
      case @domain 
        when 'admin'
          redirect_to new_manager_restaurant_user_session_path and return
        when 'xxx'
          
        end
    end
  end

  def set_languages
    @languages = Language.all
  end

  def choose_locale
    I18n.locale = cookies[:locale] || 'en'
    @language = cookies[:language] || 'English'
  end
end
