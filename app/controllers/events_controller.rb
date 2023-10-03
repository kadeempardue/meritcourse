class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @event = Event.create(whitelisted_params)

    response.set_header('X-Resource-ID', @event&.id)

    respond_to do |format|
      format.json  { render json: { notice: t("messages.successful_create"), id: @event&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:event).permit(:message_type, :uuid, message: {})
  end
end
