# frozen_string_literal: true

class Patrons::PasswordsController < Devise::PasswordsController
  before_action :configure_account_update_params, only: [:update]
  # before_action :account_update_params, only: [:update]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    byebug
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:has_no_password])
  end

  # def account_update_params
  #   params.permit(:patron).permit(:has_no_password)
  # end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
