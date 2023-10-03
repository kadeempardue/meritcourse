class EnrollmentsController < ApplicationController
  include Accessible

  before_action :authenticate_student!, only: [:create, :destroy]

  def create
    pusher_page
    @course = Course.friendly.find(params[:course_id])
    return redirect_to course_path(@course) if !course_is_accessible?

    @enrollment = @course.enrollments.create(({
      student: current_student,
      enrollment_date: Time.now,
      enrollment_status: I18n.t("enrollment_statuses")[0]
    }))

    if @enrollment.valid?
      response.set_header('X-Resource-ID', @enrollment.id)

      if @course.lessons.present? && @course.lessons.first.is_scheduled?
        flash[:notice] = t("messages.successful_enroll_scheduled")
        return redirect_to course_path(@course)
      else
        flash[:notice] = t("messages.successful_enroll")
        return redirect_to course_lessons_path(@course)
      end
    end

    flash[:error] = t("messages.failed_enroll")
    redirect_to new_course_enrollment_path(@course)
  end


  def update
    pusher_page
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
    pusher_page
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
