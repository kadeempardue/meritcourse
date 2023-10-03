class MarketingListsController < ApplicationController
  def create
    @marketing_list = MarketingList.create(whitelisted_params)
    if @marketing_list.valid?
      postmark_service.public_send("send_#{whitelisted_params[:list_name]}", whitelisted_params.merge(root_url: request.base_url))
      response.set_header('X-Resource-ID', @marketing_list.id)
      return render json: { status: true, notice: t("messages.list_signup") }
    end

    return render json: { status: false, error: t("messages.list_fail_signup") }
  end

  private

  def whitelisted_params
    params.require(:marketing_list).permit(:list_name, :first_name, :email)
  end
end
