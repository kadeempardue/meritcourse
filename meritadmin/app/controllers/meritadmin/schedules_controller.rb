class Meritadmin::SchedulesController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    @course = Course.friendly.find(params[:course_id])
    @on_lesson_page = params[:on_lesson_page] == "true"

    @schedules =
      if @on_lesson_page
        Schedule.where(lesson: @lesson)
      else
        @course.lessons.map(&:schedules).flatten.compact
      end

    respond_to do |format|
      format.js
    end
  end

  def create
    @course = Course.friendly.find(params[:course_id])
    @on_lesson_page = true

    @schedules = Schedule.where(lesson: @lesson)

    respond_to do |format|
      format.js { render :index }
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule&.destroy
    response.set_header('X-Resource-ID', @schedule&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @schedule&.id.to_s } }
    end
  end
end
