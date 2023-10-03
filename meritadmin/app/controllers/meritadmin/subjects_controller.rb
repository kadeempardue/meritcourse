class Meritadmin::SubjectsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Subject.all
    @subjects =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :name).search(params[:q]).or(
          DbTextSearch::FullText.new(records, :description).search(params[:q])
        )
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @subject = Subject.new
  end

  def show
    @subject = Subject.friendly.find(params[:id])
  end

  def create
    @subject = Subject.create(whitelisted_params)
    if @subject.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @subject.id)
      return redirect_to subject_path(@subject)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_subject_path(Subject.new)
  end

  def edit
    @subject = Subject.friendly.find(params[:id])
  end

  def update
    @subject = Subject.friendly.find(params[:id])
    if @subject&.update(whitelisted_params)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @subject.id)
      return redirect_to subject_path(@subject)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_subject_path(@subject)
  end

  def destroy
    @subject = Subject.friendly.find(params[:id])
    @subject&.destroy
    response.set_header('X-Resource-ID', @subject&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @subject&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:subject).permit(:name, :icon_url, :is_preview, :description)
  end
end
