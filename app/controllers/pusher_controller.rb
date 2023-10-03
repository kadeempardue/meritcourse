class PusherController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def log; end;

  def who_is_online
    refresh_firebase_tokens(current_student_or_staff) if student_or_staff_signed_in? && current_student_or_staff.firebase_token_expired?

    Pusher.trigger('online', 'i-am', {
      message: "#{pusher_name} is online",
      uuid: pusher_uuid,
      time: Time.now
    })

    render json: { status: :ok }
  end

  def webhook
    webhook = Pusher::WebHook.new(request)
    if webhook.valid?
      webhook.events.each do |event|
        Rails.logger.info(event)
      end
      render json: { status: :ok }, status: 200
    else
      render json: { status: :ok }, status: 300
    end
  end
end
