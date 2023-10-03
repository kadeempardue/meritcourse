class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def webhook
    stripe_service.handle_webhook_response(webhook_type, { data: webhook_data, root_url: request.base_url, postmark_service: postmark_service })

    respond_to do |format|
      format.json  { render json: { status: true } }
    end
  end

  private

  def whitelisted_params
    params.require(:stripe).permit(:type, data: {})
  end

  def webhook_type
    whitelisted_params[:type]
  end

  def webhook_data
    whitelisted_params[:data].fetch(:object, {})
  end
end
