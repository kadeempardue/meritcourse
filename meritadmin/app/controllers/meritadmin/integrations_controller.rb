class Meritadmin::IntegrationsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    @stripe_connect_account = @tenant.stripe_connect_account
    @postmark_settings = @tenant.postmark_setting
  end

  def stripe
    @stripe_connect_account = @tenant.stripe_connect_account

    if @stripe_connect_account
      flash[:notice] = "You already have connected stripe account"
      return redirect_to integrations_path
    end
  end
end
