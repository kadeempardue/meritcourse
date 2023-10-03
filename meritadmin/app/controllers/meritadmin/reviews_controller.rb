class Meritadmin::ReviewsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    @course = Course.friendly.find(params[:course_id])
  end

  def new
    @course = Course.friendly.find(params[:course_id])
    @review = Review.new
  end

  def show
    @course = Course.friendly.find(params[:course_id])
    @review = Review.find(params[:id])
    @student = @review.author
  end

  def create
    @course = Course.friendly.find(params[:course_id])
    @review = @course.reviews.create(sanitize_params(whitelisted_params))
    if @review.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @review.id)
      return redirect_to course_path(@course)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_course_review_path(@course)
  end

  def edit
    @course = Course.friendly.find(params[:course_id])
    @review = Review.find(params[:id])
  end

  def update
    @course = Course.friendly.find(params[:course_id])
    @review = Review.find(params[:id])
    if @review&.update(sanitize_params(whitelisted_params))
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @review.id)
      return redirect_to course_review_path(@course, @review, anchor: 'reviews')
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_course_review_path(@course, @review)
  end

  def destroy
    @course = Course.friendly.find(params[:course_id])
    @review = Review.find(params[:id])

    @review&.destroy
    response.set_header('X-Resource-ID', @review&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @review&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:review).permit(:comment, :rating, :student_id)
  end
end
