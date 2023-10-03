module Serviceable
  extend ActiveSupport::Concern

  included do
    def postmark_service
      @postmark_service ||= PostmarkService.new(@tenant)
    end

    def twilio_service
      @twilio_service ||= TwilioService.new
    end

    def firebase_service
      @firebase_service ||= FirebaseService.new
    end

    def stripe_service
      @stripe_service ||= StripeService.new(@tenant)
    end
  end
end
