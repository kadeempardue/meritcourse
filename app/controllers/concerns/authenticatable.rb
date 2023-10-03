module Authenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :student_signed_in?, :authenticate_student!, :current_student
    helper_method :staff_signed_in?, :authenticate_staff!, :current_staff
    helper_method :student_or_staff_signed_in?, :authenticate_student_or_staff!, :current_student_or_staff
  end

  def current_student
    return nil unless session[:uuid].present?
    @current_student ||= Student.find_by(uuid: session[:uuid])
  end

  def current_staff
    return nil unless session[:uuid].present?
    @current_staff ||= Staff.find_by(uuid: session[:uuid])
  end

  def current_student_or_staff
    current_student || current_staff
  end

  def student_signed_in?
    return false unless current_student.present?
    return false unless current_student.firebase_expiration.present?
    Time.now < current_student.firebase_expiration.localtime
  end

  def staff_signed_in?
    return false unless current_staff.present?
    return false unless current_staff.firebase_expiration.present?
    Time.now < current_staff.firebase_expiration.localtime
  end

  def student_or_staff_signed_in?
    student_signed_in? || staff_signed_in?
  end

  def authenticate_student!
    unless student_signed_in?
      admin_session = session["warden.user.admin_user.key"]
      reset_session
      session["warden.user.admin_user.key"] = admin_session
      flash[:notice] = I18n.t("messages.sign_in_again")
      redirect_to new_session_path
    end
  end

  def authenticate_staff!
    unless staff_signed_in?
      admin_session = session["warden.user.admin_user.key"]
      reset_session
      session["warden.user.admin_user.key"] = admin_session
      flash[:notice] = I18n.t("messages.sign_in_again")
      redirect_to new_session_path
    end
  end

  def authenticate_student_or_staff!
    unless student_signed_in? || staff_signed_in?
      admin_session = session["warden.user.admin_user.key"]
      reset_session
      session["warden.user.admin_user.key"] = admin_session
      flash[:notice] = I18n.t("messages.sign_in_again")
      redirect_to new_session_path
    end
  end

  def refresh_firebase_tokens(user)
    token_hash = firebase_service.exchange_refresh_token(user.firebase_refresh_token, @tenant.firebase_tenant_id) rescue {}

    if token_hash["access_token"] && user.update_firebase_token(
          firebase_refresh_token: token_hash["refresh_token"],
          firebase_id_token:token_hash["access_token"],
          firebase_issued_at: Time.now.to_datetime,
          firebase_expiration: 1.hour.from_now.localtime.to_datetime
        )

      Pusher.trigger('who-is-refreshed', 'i-am', {
        message: "#{user.name} is refreshed",
        uuid: user.uuid,
        time: Time.now,
        firebase_refresh_token: user.firebase_refresh_token,
        firebase_id_token: user.firebase_id_token,
        firebase_issued_at: user.firebase_issued_at,
        firebase_expiration: user.firebase_expiration
      })
    end
    token_hash
  end
end
