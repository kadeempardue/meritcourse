class Meritadmin::MembershipsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!
  before_action :authenticate_connected_stripe_account!, only: %w(payouts account)
  include Meritadmin::ApplicationHelper

  def payouts
    stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant) rescue nil
    redirect_to Meritadmin::StripeService.new(stripe_connect_account).express_link(stripe_express_redirect_url)
  end

  def account
    stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant) rescue nil
    redirect_to "#{Meritadmin::StripeService.new(stripe_connect_account).express_link(stripe_express_redirect_url)}#/account"
  end
end
