# frozen_string_literal: true

module Patrons
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: [:new, :create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      begin
        patron = Patron.where(:email => params[:patron][:email].downcase).first_or_create!(
          :password =>  Patrons::BaseController::DEFAULT_PATRON_PASSWORD,
          :password_confirmation => Patrons::BaseController::DEFAULT_PATRON_PASSWORD,
          :has_no_password => true,
        )
        patron.redirect_after_signup_to = params[:patron][:redirect_after_signup_to]
        sign_in_and_redirect(patron)
      rescue StandardError => e
      end
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:redirect_after_signup_to])
    end
    
    def after_sign_in_path_for(resource)
      resource.redirect_after_signup_to || super
    end
  end
end
