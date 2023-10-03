class ReviewsController < ApplicationController
  before_action :authenticate_student!, only: [:create]

  def create
    @course = Course.friendly.find(params[:course_id])
    @enrollment = @course.enrollments.where(student: current_student, enrollment_status: "Active").first
    @review = @course.reviews.build(whitelisted_params.merge(student: current_student))

    if @enrollment.present? && @review.save && @review.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @review.id)
      return redirect_to course_path(@course)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to course_path(@course)
  end

  private

  def whitelisted_params
    params.require(:review).permit(:comment, :rating, :course_id)
  end
end
