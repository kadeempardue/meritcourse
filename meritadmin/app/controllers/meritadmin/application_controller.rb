class Meritadmin::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :setting, :stripe_connect_account

  include ::Detectable
  include ::Serviceable
  include ::Authenticatable

  def setting
    @setting = @tenant.setting || @tenant.create_setting
  end

  def stripe_connect_account
    @stripe_connect_account = @tenant&.stripe_connect_account
  end

  protected

  def authenticate_admin_user!
    return super if admin_user_signed_in?
    redirect_to new_admin_user_session_path
  end

  def authenticate_membership_portal!
    redirect_to admin_root_path unless setting.is_membership_portal?
  end

  def authenticate_connected_stripe_account!
    stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant) rescue nil
    unless stripe_connect_account.present?
      flash[:error] = I18n.t("messages.connect_stripe_account")
      redirect_to admin_root_path
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    "/admin"
  end

  def after_sign_out_path_for(resource_or_scope)
    admin_root_path
  end

  def sanitize_params(params)
    params.to_h.each { |k,v| params[k] = helpers.sanitize(v) }
    params
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
