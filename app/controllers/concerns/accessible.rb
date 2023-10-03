module Accessible
  extend ActiveSupport::Concern
  included do end;

  def set_course_button_action
    return @course_button_action = "accessible" if admin_user_signed_in? || staff_signed_in?
    return @course_button_action = "preview" if @course.is_preview?
    return @course_button_action = "login" if !student_signed_in?
    return @course_button_action = "accessible" unless setting.is_membership_portal?
    return @course_button_action = "no_plan" unless current_student.current_plan.present?
    return @course_button_action = "change_plan" unless @course.plan_access.include?(current_student.current_plan.id.to_s)

    @course_button_action = "accessible"
  end

  def course_is_accessible?
    set_course_button_action

    case @course_button_action
    when "accessible"
      true
    when "preview", "no_plan", "change_plan", "login"
      false
    end
  end
end
