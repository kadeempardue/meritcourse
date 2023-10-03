# frozen_string_literal: true

class Meritadmin::PasswordsController < Devise::PasswordsController
  include Detectable
  prepend_before_action :set_tenant

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
  # def update
  #   super
  # end

  # protected

  def after_resetting_password_path_for(resource)
    "/admin"
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    "/admin/auth/password/new"
  end
end
