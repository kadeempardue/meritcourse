class SchedulesController < Meritadmin::ApplicationController

  def index
    @course = Course.friendly.find(params[:course_id])
    @schedules = @course.lessons.map(&:schedules).flatten.compact

    respond_to do |format|
      format.js
    end
  end
end
