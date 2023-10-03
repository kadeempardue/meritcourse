class AccountsController < ApplicationController
  before_action :authenticate_student_or_staff!

  def index
    pusher_page
    @title = "My Account"
  end

  def update
    pusher_page
    # Refresh token first
    if (whitelisted_params[:email].present? && whitelisted_params[:email] != current_student_or_staff.email) || (whitelisted_params[:password].present? && whitelisted_params[:password] == whitelisted_params[:confirm_password])
      token_hash = firebase_service.update_email(current_student_or_staff.uuid, current_student_or_staff.firebase_id_token, whitelisted_params[:email], whitelisted_params[:password], @tenant.firebase_tenant_id)
      # Update tokens
      if token_hash["idToken"]
        token_update = current_student_or_staff.update_firebase_token(
          firebase_refresh_token: token_hash["refreshToken"],
          firebase_id_token: token_hash["idToken"],
          firebase_issued_at: Time.now.to_datetime,
          firebase_expiration: 1.hour.from_now.localtime.to_datetime
        )

          if token_update && current_student_or_staff.update(whitelisted_params.except(:password, :confirm_password))
          flash[:notice] = t("messages.successful_save")
          response.set_header('X-Resource-ID', current_student_or_staff.id)
          return redirect_to destroy_session_path
        end
      end
    end

    flash[:error] = t("messages.failed_save")
    redirect_to account_path
  end

  private

  def whitelisted_params
    params.require(:user).permit(:email, :password, :confirm_password) rescue {}
  end
end
