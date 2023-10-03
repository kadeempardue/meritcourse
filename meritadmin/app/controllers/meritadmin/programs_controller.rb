class Meritadmin::ProgramsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Program.all
    @programs =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :name).search(params[:q]).or(
          DbTextSearch::FullText.new(records, :description).search(params[:q]).or(
            DbTextSearch::FullText.new(records, :concepts).search(params[:q])
          )
        )
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @program = Program.new
    @courses = Course.all
  end

  def show
    @program = Program.friendly.find(params[:id])
  end

  def create
    @program = Program.create(whitelisted_params)
    if @program.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @program.id)
      return redirect_to program_path(@program)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_program_path(@program)
  end

  def edit
    @program = Program.friendly.find(params[:id])
    @courses = Course.all
  end

  def update
    @program = Program.friendly.find(params[:id])
    if @program&.update(whitelisted_params)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @program.id)
      return redirect_to program_path(@program)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_program_path(@program)
  end

  def destroy
    @program = Program.friendly.find(params[:id])
    @program&.destroy
    response.set_header('X-Resource-ID', @program&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @program&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:program).permit(:name, :description, :featured_image_url, course_plan: [], concepts: [], outcomes: [])
  end
end
