class HomeController < ApplicationController
  helper_method :articles, :programs, :students, :courses, :enrolled_courses, :lessons, :enrollments, :subjects, :reviews

  def index
    pusher_page
    return redirect_to onboarding_path if student_signed_in? && !current_student.onboarding_complete?
    return render(:index) if staff_signed_in?

    student_signed_in? ? render(:dashboard) : render(:index)
  end

  def get_token
    render json: { data: { token: firebase_service.generate_custom_token_claim(@tenant&.firebase_tenant_id, params[:username]) } }
  end

  private

  def articles
    @articles ||= Article.published
  end

  def programs
    @programs ||= Program.all
  end

  def students
    @students ||= Student.all
  end

  def courses
    @courses ||= Course.not_archived
  end

  def enrolled_courses
    return [] unless student_signed_in?
    @enrolled_courses ||= current_student.enrolled_courses.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def lessons
    @lessons ||= courses.map(&:lessons)
  end

  def enrollments
    @enrollments ||= Enrollment.all
  end

  def subjects
    @subjects ||= Subject.all
  end

  def reviews
    @reviews ||= Review.all
  end
end
