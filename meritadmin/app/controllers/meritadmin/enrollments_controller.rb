class Meritadmin::EnrollmentsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    @course = Course.friendly.find(params[:course_id])
  end

  def new
    @course = Course.friendly.find(params[:course_id])
    @enrollment = Enrollment.new
  end

  def show
    @course = Course.friendly.find(params[:course_id]) rescue nil
    return redirect_to root_path unless @course

    @enrollment = @course.enrollments.find(params[:id]) rescue nil
    return redirect_to course_path(@course) unless @enrollment

    @student = @enrollment.student
  end

  def create
    @course = Course.friendly.find(params[:course_id])
    @enrollment = @course.enrollments.create(sanitize_params(whitelisted_params))
    if @enrollment.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @enrollment.id)
      return redirect_to course_path(@course)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_course_enrollment_path(@course)
  end

  def edit
    @course = Course.friendly.find(params[:course_id])
    @enrollment = @course.enrollments.find(params[:id])
  end

  def update
    @course = Course.friendly.find(params[:course_id])
    @enrollment = Enrollment.find(params[:id])
    if @enrollment&.update(sanitize_params(whitelisted_params))
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @enrollment.id)
      return redirect_to course_enrollment_path(@course, @enrollment, anchor: 'enrollments')
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_course_enrollment_path(@course, @enrollment)
  end

  def destroy
    @course = Course.friendly.find(params[:course_id])
    @enrollment = Enrollment.find(params[:id])
    @student = @enrollment.student

    @enrollment&.destroy
    response.set_header('X-Resource-ID', @enrollment&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to student_path(@student)
      end
      format.json  { render json: { notice: t("messages.successful_withdrawn"), id: @course&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:enrollment).permit(:enrollment_date, :enrollment_status, :student_id)
  end
end
