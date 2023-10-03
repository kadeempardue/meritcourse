class Meritadmin::StaffsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Staff.all
    @staffs =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :email).search(params[:q]).or(
          DbTextSearch::FullText.new(records, :first_name).search(params[:q]).or(
            DbTextSearch::FullText.new(records, :last_name).search(params[:q])
          )
        )
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @staff = Staff.new
  end

  def show
    @staff = Staff.find(params[:id])
  end

  def create
    @staff = Staff.create(sanitize_params(whitelisted_params))
    if @staff.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @staff.id)
      return redirect_to staff_path(@staff)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_staff_path(Staff.new)
  end

  def edit
    @staff = Staff.find(params[:id])
  end

  def update
    @staff = Staff.find(params[:id])

    if whitelisted_params[:email].present?
      # TODO DOES NOT WORK
      refresh_firebase_tokens(@staff)

      token_hash = firebase_service.update_email(@staff.uuid, @staff.firebase_id_token, whitelisted_params[:email], nil, @tenant.firebase_tenant_id)
    end

    if @staff&.update(sanitize_params(whitelisted_params))

      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @staff.id)
      return redirect_to staff_path(@staff)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_staff_path(@staff)
  end

  def destroy
    @staff = Staff.find(params[:id])
    CloudinaryService.delete_image(@staff.profile_image)
    response.set_header('X-Resource-ID', @staff&.id)

    if @staff&.destroy
      flash[:notice] = t("messages.successful_destroy")
      render json: { notice: t("messages.successful_destroy"), id: @staff&.id.to_s }
    else
      error_msg = t("messages.failed_destroy") + " #{@staff.errors.messages.values.flatten.join(' ')}"
      # flash[:error] = error_msg
      render json: { error: error_msg, id: @staff&.id.to_s }, status: 400
    end
  end

  private

  def whitelisted_params
    params.require(:staff).permit(:first_name, :last_name, :email, :profile_image,
      :city, :state, :zip)
  end
end
