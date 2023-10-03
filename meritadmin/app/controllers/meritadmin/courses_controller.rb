class Meritadmin::CoursesController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Course.all
    @courses =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :name).search(params[:q]).or(
          DbTextSearch::FullText.new(records, :objectives).search(params[:q])
        )
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @course = Course.new
  end

  def show
    @course = Course.friendly.find(params[:id]) rescue nil
    return redirect_to admin_root_path unless @course

    @course_subject = @course.subject
    @schedules = @course.lessons.map(&:schedules).flatten.compact
  end

  def analytics
    @course = Course.friendly.find(params[:course_id]) rescue nil
    return redirect_to admin_root_path unless @course

    @enrollments = @course.enrollments.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def lesson_analytics
    @course = Course.friendly.find(params[:course_id]) rescue nil
    @lesson = @course.lessons.find(params[:lesson_id]) rescue nil
    return redirect_to admin_root_path unless @course || @lesson

    @enrollments = @course.enrollments
  end

  def send_badge
    student = Student.find_by(email: params[:email])
    return render json: { error: "No Student" } unless student

    badge = Badge.find(params[:badge_id])
    return render json: { error: "No Badge" } unless badge

    lesson = Lesson.find(params[:lesson_id])
    return render json: { error: "No Lesson" } unless lesson

    results = postmark_service.send_badge(student, { root_url: request.base_url, cc: current_admin_user.email, badge: badge, lesson_name: params[:lesson_name] })

    if results.present? && results[:message].include?("OK")
      awarded_badge = AwardedBadge.find_or_initialize_by(student: student, badge: badge, lesson: lesson)

      if awarded_badge.valid? && awarded_badge.save
        UnawardedBadge.where(student: student, badge: badge, lesson: lesson).destroy_all

        return render json: { notice: "Successfully issued badge!" }
      end
    end

    render json: { error: "Could not issue badge!" }
  end

  def deny_badge
    student = Student.find_by(email: params[:email])
    return render json: { error: "No Student" } unless student

    badge = Badge.find(params[:badge_id])
    return render json: { error: "No Badge" } unless badge

    lesson = Lesson.find(params[:lesson_id])
    return render json: { error: "No Lesson" } unless lesson

    unawarded_badge = UnawardedBadge.find_or_initialize_by(student: student, badge: badge, lesson: lesson)

    if unawarded_badge.valid? && unawarded_badge.save
      AwardedBadge.where(student: student, badge: badge, lesson: lesson).destroy_all
      return render json: { notice: "Successfully denied badge!" }
    end

    render json: { error: "Could not deny badge!" }
  end

  def create
    @course = Course.create(whitelisted_params)
    if @course.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @course.id)
      return redirect_to course_path(@course)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_course_path(Course.new)
  end

  def edit
    @course = Course.friendly.find(params[:id])
  end

  def update
    @course = Course.friendly.find(params[:id])
    if @course&.update(whitelisted_params)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @course.id)
      return redirect_to course_path(@course)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_course_path(@course)
  end

  def destroy
    @course = Course.friendly.find(params[:id])
    @course&.destroy
    response.set_header('X-Resource-ID', @course&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @course&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:course).permit(:name, :featured_preview_video_url,
      :featured_preview_image_url, :is_preview, :archived, :level, :excerpt, :description, :zip,
      :objectives, :requirements, :subject_id, :video_caption, plan_access: [])
  end
end
