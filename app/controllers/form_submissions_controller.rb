class FormSubmissionsController < ApplicationController
  def show
    redirect_to root_path unless admin_user_signed_in?
    @form = Form.friendly.find(params[:form_id]) rescue nil
    redirect_to root_path unless @form
    @form_submission = FormSubmission.find(params[:id])
    redirect_to root_path unless @form.form_submissions.include?(@form_submission)
  end

  def create
    pusher_page
    @form = Form.friendly.find(params[:form_id]) rescue nil
    redirect_to root_path unless @form
    params.permit!
    @form_submission = @form.form_submissions.create(({
      data: @form.data,
      submission: params.to_h,
      first_name: form_submission_params[:first_name],
      last_name: form_submission_params[:last_name],
      email: params[:email]
    }))

    if @form_submission.valid?
      response.set_header('X-Resource-ID', @form_submission.id)
      flash[:notice] = t("messages.successful_form_submission")
      if @form.register_account?
        CreateStudentAccountFromFormWorker.new.perform(@form, @form_submission)
      end
      url = @form.redirect_url.presence || root_path
      return redirect_to url
    end

    flash[:error] = t("messages.failed_form_submission")
    redirect_to form_path(@form)
  end

  private

  def firebase_user
    @firebase_user ||= firebase_service.create_user(params[:email], params[:password], @tenant&.firebase_tenant_id)
  end

  def form_submission_params
    params.require(:form_submission).permit(:first_name, :last_name, :email)
  end
end
