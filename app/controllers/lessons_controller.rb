class LessonsController < ApplicationController
  include Accessible

  def index
    pusher_page
    @course = Course.friendly.find(params[:course_id])
    if @course.lessons.present?
      redirect_to course_lesson_path(@course, @course.lessons.first)
    else
      flash[:error] = I18n.t("messages.no_lessons")
      redirect_to course_path(@course)
    end
  end

  def show
    pusher_page

    @course = Course.friendly.find(params[:course_id]) rescue nil
    return redirect_to root_path if @course.blank?

    @lesson = @course.lessons.find(params[:id])

    if helpers.preview_mode?
      set_livestream
      return
    end

    if @lesson.present? && @lesson.is_archived?
      flash[:error] = I18n.t("messages.lesson_archived")

      if params[:r].present?
        return redirect_to course_lesson_path(@course, params[:r])
      else
        return redirect_back fallback_location: course_path(@course)
      end
    end

    if @lesson.present? && @lesson.is_locked?
      flash[:error] = I18n.t("messages.lesson_locked")

      if params[:r].present?
        return redirect_to course_lesson_path(@course, params[:r])
      else
        return redirect_back fallback_location: course_path(@course)
      end
    end

    # Inaccessible
    if @lesson.blank? || (!@lesson.is_preview? && !course_is_accessible?) || (!@lesson.is_preview? && !enrolled_in?(@course))
      flash[:error] = I18n.t("messages.not_enrolled")

      return redirect_to course_path(@course)
    end

    # Schedule Availability
    if (!@lesson.is_preview? && @lesson.is_scheduled?)
      # On Time?
      if @lesson.schedules_in_progress.blank?
        flash[:error] = I18n.t("messages.not_available_yet")
        return redirect_back fallback_location: course_path(@course)
      end
    end

    @prev_lesson = @lesson.prev
    @next_lesson = @lesson.next

    set_livestream

    pusher_lesson
  end

  private

  def generate_twilio_access_token
    @identity = (current_student || current_staff).uuid
    @grant, @room, @access_token = twilio_service.create_access_token(@identity, @lesson.unique_livestream_name(@tenant&.key))
  end

  def set_livestream
    generate_twilio_access_token if student_signed_in? || staff_signed_in?

    if @lesson.is_livestream?
      room_sid = twilio_service.get_room(@room)&.sid

      @hosts = []
      @hosts << current_staff if @lesson.host == current_staff

      @participants = twilio_service.get_participants(room_sid).map do |participant|
        next if participant == current_staff
        Student.find_by(uuid: participant.identity) || Staff.find_by(uuid: participant.identity)
      end.unshift(current_student || current_staff).uniq.compact
    end

    @unawarded_badge = UnawardedBadge.find_by(student: current_student, lesson: @prev_lesson, display_date: nil)
    if @unawarded_badge
      @unawarded_badge.update(display_date: DateTime.now)

      if current_student
        enrolled_students = Enrollment.where(course: @course).map(&:student).uniq.reject { |s| s == current_student }
        @awarded_students = AwardedBadge.where(badge: @unawarded_badge.badge, lesson: @prev_lesson).map(&:student).uniq.reject { |s| s == current_student }.select { |s| enrolled_students.include?(s) }
      end
    end

    @awarded_badge = AwardedBadge.find_by(student: current_student, lesson: @prev_lesson, display_date: nil)
    if @unawarded_badge.blank? && @awarded_badge
     @awarded_badge.update(display_date: DateTime.now)

     if current_student
       enrolled_students = Enrollment.where(course: @course).map(&:student).uniq.reject { |s| s == current_student }
       @awarded_students = AwardedBadge.where(badge: @awarded_badge.badge, lesson: @prev_lesson).map(&:student).uniq.reject { |s| s == current_student }.select { |s| enrolled_students.include?(s) }
     end
    end
  end
end
