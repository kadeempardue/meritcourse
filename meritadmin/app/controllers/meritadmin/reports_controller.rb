class Meritadmin::ReportsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Report.all
    @reports = records.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @report = Report.new
  end

  def show
    @report = Report.find(params[:id])
  end

  def create
    csv = Meritadmin::ReportService.generate(whitelisted_params[:report_type], params[:date_range])
    respond_to do |format|
      format.html { send_data csv, filename: "#{whitelisted_params[:report_type]}-#{Date.today}.csv", disposition: 'inline', type: "text/csv; charset=utf-8; header=present" }
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report&.destroy
    response.set_header('X-Resource-ID', @report&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @report&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:report).permit(:report_type)
  end
end
