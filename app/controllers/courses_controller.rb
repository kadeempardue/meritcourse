class CoursesController < ApplicationController
  include Accessible

  def show
    pusher_page
    @course = Course.friendly.find(params[:id]) rescue nil
    unless @course.present?
      flash[:error] = I18n.t("messages.course_does_not_exist")
      return redirect_to root_path
    end
    @review = Review.new
    @enrollment = Enrollment.find_or_initialize_by(student: current_student, course_id: @course.id) if student_signed_in?
    @schedules = @course.lessons.map(&:schedules).flatten.compact
    set_course_button_action
  end
end
