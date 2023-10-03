class Meritadmin::BadgesController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Badge.all
    @badges =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :name).search(params[:q])
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @badge = Badge.new
  end

  def show
    @badge = Badge.find(params[:id])
  end

  def create
    @badge = Badge.create(attrs)
    if @badge.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @badge.id)
      return redirect_to badge_path(@badge)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_badge_path(Badge.new)
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def update
    @badge = Badge.find(params[:id])
    if @badge&.update(attrs)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @badge.id)
      return redirect_to badge_path(@badge)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_badge_path(@badge)
  end

  def destroy
    @badge = Badge.find(params[:id])

    response.set_header('X-Resource-ID', @badge&.id)

    if @badge&.destroy
      flash[:notice] = t("messages.successful_destroy")
      render json: { notice: t("messages.successful_destroy"), id: @badge&.id.to_s }
    else
      error_msg = t("messages.failed_destroy") + " #{@badge.errors.messages.values.flatten.join(' ')}"
      flash[:error] = error_msg
      render json: { error: error_msg, id: @badge&.id.to_s }, status: 400
    end
  end

  private

  def attrs
    attrs = sanitize_params(whitelisted_params)
    attrs = attrs.merge(skills: skills) if skills.present?
    attrs
  end

  def whitelisted_params
    params.require(:badge).permit(:name, :course_id, :lesson_id, :issued_by, :description, :earning_criteria, :image_url)
  end

  def skills
    @skills = JSON.parse(params[:badge][:skills]).map { |x| x["value"] }.compact rescue nil
  end
end
