class Meritadmin::LessonsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def new
    @course = Course.friendly.find(params[:course_id])
    @lesson = Lesson.new
    @lesson.is_livestream = params[:f] == "livestream"
    @lesson.schedules.build
    @module_names = @course.lesson_modules.keys
    @schedules = @lesson.schedules
    @schedule = Schedule.new
  end

  def show
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
  end

  def create
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course&.lessons.create(whitelisted_params)
    if @lesson.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @lesson.id)
      return redirect_to course_path(@course)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_course_lesson_path(@course)
  end

  def edit
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
    @module_names = @course.lesson_modules.keys
    @schedules = @lesson.schedules
    @schedule = Schedule.new
  end

  def update
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.find(params[:id])

    if @lesson&.update(whitelisted_params)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @lesson.id)
      return redirect_to course_lesson_path(@course, @lesson, anchor: 'lessons')
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_course_lesson_path(@course, @lesson)
  end

  def destroy
    @course = Course.friendly.find(params[:course_id])
    @lesson = @course.lessons.find(params[:id])

    @lesson&.destroy
    response.set_header('X-Resource-ID', @lesson&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @lesson&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:lesson).permit(:name, :module_name, :duration, :is_preview,
      :lesson_type, :video_url, :image_url, :handouts, :is_full_width, :is_livestream, :is_scheduled, :pdf_url, :host_id, :excerpt, :is_locked, :is_archived, schedules_attributes: [:start_datetime, :end_datetime])
  end
end
