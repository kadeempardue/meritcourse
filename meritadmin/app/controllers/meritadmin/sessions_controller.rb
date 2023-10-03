# frozen_string_literal: true

class Meritadmin::SessionsController < Devise::SessionsController
  include Detectable

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   flash[:error] = "Hi"
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  # To avoid prepend_before_action error
  def verify_signed_out_user
    set_tenant
    super
  end
end
