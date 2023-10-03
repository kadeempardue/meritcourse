class FormsController < ApplicationController
  def show
    pusher_page
    @form = Form.friendly.find(params[:id]) rescue nil
    redirect_to root_path unless @form
    @form_submission = FormSubmission.new
    @show_header = false
    @show_footer = false
  end

  def participant_application
  end
end
