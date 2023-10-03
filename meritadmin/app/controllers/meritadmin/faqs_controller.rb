class Meritadmin::FaqsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!, :authenticate_membership_portal!

  def index
    records = Faq.all
    @faqs =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :name).search(params[:q])
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @faq = Faq.new
  end

  def show
    @faq = Faq.find(params[:id])
  end

  def create
    @faq = Faq.create(sanitize_params(whitelisted_params))
    if @faq.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @faq.id)
      return redirect_to faq_path(@faq)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_faq_path(Faq.new)
  end

  def edit
    @faq = Faq.find(params[:id])
  end

  def update
    @faq = Faq.find(params[:id])
    if @faq&.update(sanitize_params(whitelisted_params))
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @faq.id)
      return redirect_to faq_path(@faq)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_faq_path(@faq)
  end

  def destroy
    @faq = Faq.find(params[:id])

    response.set_header('X-Resource-ID', @faq&.id)

    if @faq&.destroy
      flash[:notice] = t("messages.successful_destroy")
      render json: { notice: t("messages.successful_destroy"), id: @faq&.id.to_s }
    else
      error_msg = t("messages.failed_destroy") + " #{@faq.errors.messages.values.flatten.join(' ')}"
      flash[:error] = error_msg
      render json: { error: error_msg, id: @faq&.id.to_s }, status: 400
    end
  end

  private

  def whitelisted_params
    params.require(:faq).permit(:name, :description)
  end
end
