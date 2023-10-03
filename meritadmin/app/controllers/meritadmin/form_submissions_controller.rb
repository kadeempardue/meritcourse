class Meritadmin::FormSubmissionsController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    @form_submissions = FormSubmission.all.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def show
    @form_submission = FormSubmission.find(params[:id])
  end
end
