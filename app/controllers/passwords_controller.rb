class PasswordsController < ApplicationController
  def new
    pusher_page
    @title = "Reset Password"
  end

  def send_password_link
    pusher_page
    user = Student.find_by(email: params[:email]) || Staff.find_by(email: params[:email])

    if user.present? && password_reset_link(user.email).present? && postmark_service.send_reset_password_instructions(user, { root_url: request.base_url, oob_code: oob_code })
      flash[:notice] = I18n.t("messages.successful_password_reset_link")
      return redirect_to new_session_path
    end

    flash[:notice] = I18n.t("messages.successful_password_reset_link")
    redirect_to reset_password_path
  end

  def edit
    pusher_page
    return redirect_to reset_password_path unless params[:t]

    @title = "Change Password"
    user = Student.find_by(reset_password_token: params[:t]) || Staff.find_by(reset_password_token: params[:t])

    if user && user.reset_password_token.present? && !user.token_expired?
      @email = user.email
    else
      flash[:notice] = I18n.t("messages.password_token_expired")
      redirect_to reset_password_path
    end
  end

  def update
    pusher_page
    return redirect_to reset_password_path unless params[:t]
    user = Student.find_by(reset_password_token: params[:t]) || Staff.find_by(reset_password_token: params[:t])

    if user && user.reset_password_token.present? && !user.token_expired? && password_matches?
      results = firebase_service.change_password(user.reset_password_token, params[:password], @tenant&.firebase_tenant_id)
      if results["requestType"] == "PASSWORD_RESET"
        flash[:notice] = I18n.t("messages.successful_password_reset")
        return redirect_to new_session_path
      end
    end

    flash[:error] = I18n.t("messages.failed_password_reset")
    redirect_to change_password_path
  end

  private

  def password_matches?
    params[:password] == params[:confirm_password]
  end

  def password_reset_link(email)
    @password_reset_link ||= firebase_service.generate_password_reset_link(email, request.remote_ip, @tenant&.firebase_tenant_id)["oobLink"]
  end

  def oob_code
    return nil unless @password_reset_link.present?

    @password_reset_link.split("oobCode=")[1].split("&")[0]
  end
end
