class Meritadmin::StripeController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!
  # before_action :redirect_unless_code_and_scope, only: %w(connected)

  def create_account
    account = Stripe::Account.create({
      country: "US",
      type: "custom",
      requested_capabilities: ["card_payments", "transfers", "tax_reporting_us_1099_k"],
    })
  end

  def connected
    response = Stripe::OAuth.token({
      grant_type: "authorization_code",
      code: params[:code],
    }, {
      api_key: ENV["STRIPE_SECRET_KEY"]
    })

    stripe_connect_account = StripeConnectAccount.create!(
      token_type: response.token_type,
      stripe_publishable_key: response.stripe_publishable_key,
      scope: response.scope,
      livemode: response.livemode,
      stripe_user_id: response.stripe_user_id, # You’ll use this value to authenticate as the connected account by passing it into requests in the Stripe-Account header.
      refresh_token: response.refresh_token,
      access_token: response.access_token
    )

    @tenant&.plans.each do |plan|
      Meritadmin::StripeService.new(stripe_connect_account).create_plan(plan)
    end

    flash[:notice] = "Successfully connected Stripe Account"

    redirect_to integrations_path
  end
  #
  # def revoke
  #   connected_account_id = @tenant&.stripe_connect_account.stripe_user_id
  #
  #   Stripe::OAuth.deauthorize({
  #     client_id: ENV["STRIPE_CLIENT_ID"],
  #     stripe_user_id: connected_account_id,
  #   })
  #
  #   flash[:notice] = "Successfully disconnected Stripe account"
  #   redirect_to "/admin"
  # end

  private

  def redirect_unless_code_and_scope
    unless params[:code].present? && params[:scope] == "read_write"
      flash[:error] = "Cannot access this page"
      return redirect_to "/admin"
    end
  end
end
