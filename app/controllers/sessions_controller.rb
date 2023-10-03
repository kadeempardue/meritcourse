class SessionsController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    redirect_to root_path if student_signed_in? || staff_signed_in?
    pusher_page
    @title = "Login"
    session[:state] = params[:r] || SecureRandom.hex(24)
  end

  def create
    pusher_page
    token_hash = firebase_service.decode(params[:user]) rescue {}
    user = Student.find_by(uuid: token_hash["user_id"]) rescue nil
    user ||= Staff.find_by(uuid: token_hash["user_id"]) rescue nil

    if user&.update_firebase_token(
        firebase_refresh_token: params[:refresh_token],
        firebase_id_token: params[:user],
        firebase_issued_at: Time.at(token_hash["iat"].to_i).to_datetime,
        firebase_expiration: Time.at(token_hash["exp"].to_i).to_datetime,
      )
      session[:uuid] = token_hash["user_id"]

      return render json: { status: true }
    end

    render json: { status: false }
  end

  def destroy
    pusher_page
    admin_session = session["warden.user.admin_user.key"]
    reset_session
    session["warden.user.admin_user.key"] = admin_session
    flash[:notice] = I18n.t("messages.successful_logout")
    redirect_to logout_url.to_s
  end
end
