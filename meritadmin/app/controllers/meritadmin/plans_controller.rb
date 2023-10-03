class Meritadmin::PlansController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!, :authenticate_membership_portal!
  before_action :authenticate_connected_stripe_account!
  before_action :redirect_plan_limit_reached!, only: [:new, :create]

  def index
    records = Plan.all
    @plans =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :name).search(params[:q])
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @plan = Plan.new
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def create
    stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant)
    @plan = Plan.new(sanitize_params(whitelisted_params))
    if Meritadmin::StripeService.new(stripe_connect_account).create_plan(@plan)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @plan.id)
      return redirect_to plan_path(@plan)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_plan_path(Plan.new)
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant)
    @plan = Plan.find(params[:id])

    if @plan&.amount != whitelisted_params[:amount].to_i || @plan&.interval != whitelisted_params[:interval]
      success = Meritadmin::StripeService.new(stripe_connect_account).update_plan(@plan, sanitize_params(whitelisted_params))
    else
      @plan.stripe_connect_account = stripe_connect_account
      success = @plan&.update(sanitize_params(whitelisted_params))
    end

    if success
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @plan.id)
      return redirect_to plan_path(@plan)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_plan_path(@plan)
  end

  def destroy
    @plan = Plan.find(params[:id])
    response.set_header('X-Resource-ID', @plan&.id)

    if @plan&.destroy
      flash[:notice] = t("messages.successful_destroy")
      render json: { notice: t("messages.successful_destroy"), id: @plan&.id.to_s }
    else
      error_msg = t("messages.failed_destroy") + " #{@plan.errors.messages.values.flatten.join(' ')}"
      render json: { error: error_msg, id: @plan&.id.to_s }, status: 400
    end
  end

  private

  def whitelisted_params
    params.require(:plan).permit(:name, :amount, :interval, :currency, :color,
      :recommended, :order, :feature_1, :feature_1_help_text, :feature_2, :feature_2_help_text, :feature_3, :feature_3_help_text,
      :feature_4, :feature_4_help_text, :feature_5, :feature_5_help_text, :description)
  end

  def redirect_plan_limit_reached!
    plans = Plan.all
    return redirect_to plans_path if plans.count >= 3
  end
end
