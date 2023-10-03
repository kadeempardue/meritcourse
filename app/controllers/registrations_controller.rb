class RegistrationsController < ApplicationController
  before_action :redirect_unless_has_registration_enabled?
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    pusher_page
    redirect_to root_path if student_signed_in?
    @title = "Sign Up"
    @faqs = Faq.all if setting.is_membership_portal?
    @stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant) rescue nil
    @first_plan = Plan.find_by(order: 1)
    @recommended_plan = Plan.find_by(recommended: true)
    @last_plan = Plan.find_by(order: 3)
  end

  def upgrade
    pusher_page
    redirect_to root_path unless student_signed_in?
    @title = "Upgrade"
    @faqs = Faq.all if setting.is_membership_portal?
    @stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant) rescue nil
    @first_plan = Plan.find_by(order: 1)
    @recommended_plan = Plan.find_by(recommended: true)
    @last_plan = Plan.find_by(order: 3)
    @current_plan = current_student.current_plan
  end

  def create
    pusher_page
    if params[:tos_acceptance_date] != "on"
      msg = "Terms of Service and Privacy Policy were not accepted"
      flash[:error] = msg
      Bugsnag.notify(msg) if Rails.env.production?

      return redirect_to new_registration_path
    end

    if setting.is_membership_portal?
      create_stripe_customer

      if @stripe_customer.blank? || @stripe_subscription.blank?
        msg = "Subscription could not be created"
        flash[:error] = msg
        Bugsnag.notify(msg) if Rails.env.production?

        return redirect_to new_session_path
      end
    end

    if firebase_user.present? && firebase_user["error"].present?
      msg = "Account could not be created. #{firebase_user["error"]["message"]}"
      flash[:error] = msg
      Bugsnag.notify(msg) if Rails.env.production?

      return redirect_to new_registration_path
    end

    if firebase_user.present? && (firebase_user["idToken"].blank? || firebase_user["localId"].blank?)
      msg = "Account could not be created. Please try again or contact support."
      flash[:error] = msg
      Bugsnag.notify(msg) if Rails.env.production?

      return redirect_to new_registration_path
    end

    if student&.valid? && student.persisted?
      session[:uuid] = student.uuid
      flash[:notice] = I18n.t("messages.successful_registration")
      return redirect_to explore_path
    end

    msg = "RegistrationsController#create #{@tenant&.key} : #{I18n.t("messages.failed_registration")}"
    flash[:error] = msg
    Bugsnag.notify(msg) if Rails.env.production?
    redirect_to new_registration_path
  end

  private

  def redirect_unless_has_registration_enabled?
    redirect_to root_path unless setting.registration_enabled?
  end

  def firebase_user
    @firebase_user ||= firebase_service.create_user(params[:email], params[:password], @tenant&.firebase_tenant_id)
  end

  def create_stripe_customer
    results = stripe_service.create_customer_with_subscription({
      plan_id: params[:plan_id],
      membership_interval: params[:membership_interval],
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      cc_name: params[params.keys.find { |e| e.starts_with?("cc-name-") }],
      zip: params[:zip],
      source: params[:source]
    })
    @stripe_customer = results[0]
    @stripe_subscription = results[1]
  end

  def student
    now = Time.now
    @student ||= Student.create({
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      tos_agreement: true,
      tos_acceptance_date: DateTime.now,
      uuid: firebase_user["localId"],
      firebase_refresh_token: firebase_user["refreshToken"],
      firebase_id_token: firebase_user["idToken"],
      firebase_issued_at: now.to_datetime,
      firebase_expiration: (now + firebase_user["expiresIn"].to_i).to_datetime,
      membership_interval: params[:membership_interval],
      membership_status: "Active",
      membership_id: @stripe_customer&.id,
      membership_subscription_id: @stripe_subscription&.id,
      current_plan_id: params[:plan_id]
    })
  end
end
