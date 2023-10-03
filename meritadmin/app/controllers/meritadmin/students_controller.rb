class Meritadmin::StudentsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Student.all
    @students =
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
    @student = Student.new
  end

  def show
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.create(sanitize_params(whitelisted_params))
    if @student.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @student.id)
      return redirect_to student_path(@student)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_student_path(Student.new)
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])

    if whitelisted_params[:email].present?
      # TODO DOES NOT WORK
      refresh_firebase_tokens(@student)

      token_hash = firebase_service.update_email(@student.uuid, @student.firebase_id_token, whitelisted_params[:email], nil, @tenant.firebase_tenant_id)
    end

    if @student&.update(sanitize_params(whitelisted_params))

      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @student.id)
      return redirect_to student_path(@student)
    end
  end

  def destroy
    @student = Student.find(params[:id])
    CloudinaryService.delete_image(@student.profile_image)
    response.set_header('X-Resource-ID', @student&.id)

    if @student&.destroy
      flash[:notice] = t("messages.successful_destroy")
      render json: { notice: t("messages.successful_destroy"), id: @student&.id.to_s }
    else
      error_msg = t("messages.failed_destroy") + " #{@student.errors.messages.values.flatten.join(' ')}"
      # flash[:error] = error_msg
      render json: { error: error_msg, id: @student&.id.to_s }, status: 400
    end
  end

  private

  def whitelisted_params
    params.require(:student).permit(:first_name, :last_name, :email, :profile_image,
      :city, :state, :zip, :membership_id, :membership_status, :membership_interval, :tos_agreement)
  end
end
