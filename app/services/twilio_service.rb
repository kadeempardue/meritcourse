class TwilioService
  TWILIO_VIDEO_API_URL = "https://video.twilio.com"
  ACCOUNT_SID = ENV["TWILIO_ACCOUNT_SID"]
  TWILIO_AUTH_TOKEN = ENV["TWILIO_AUTH_TOKEN"]
  TWILIO_API_KEY = ENV["TWILIO_API_KEY"]
  TWILIO_API_SECRET = ENV["TWILIO_API_SECRET"]

  def create_access_token(identity, room_unique_name)
    token = Twilio::JWT::AccessToken.new(ACCOUNT_SID, TWILIO_API_KEY, TWILIO_API_SECRET, [], identity: identity);

    # Create Video grant for our token
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = room_unique_name
    token.add_grant(grant)

    [grant, grant.room, token.to_jwt]
  rescue => e
    msg = "TwilioService: Could not generate access token #{e}"
    Bugsnag.notify(msg) if Rails.env.production?
    Rails.logger.error(msg)
    nil
  end

  def get_participants(room_sid)
    return [] unless room_sid

    client.video.rooms(room_sid).participants.list(status: 'connected')
  rescue => e
    msg = "TwilioService: Could not get room participants #{e}"
    Bugsnag.notify(msg) if Rails.env.production?
    Rails.logger.error(msg)
    []
  end

  def get_room(room_id)
    client.video.rooms(room_id).fetch rescue nil
  end

  def create_room(unique_name)
    return false unless unique_name

    room = client.video.rooms.create(
     record_participants_on_connect: true,
     # status_callback: 'http://example.org',
     type: 'group',
     unique_name: unique_name
   )

   room.sid
  rescue => e
    msg = "TwilioService: Could not get room #{e}"
    Bugsnag.notify(msg) if Rails.env.production?
    Rails.logger.error(msg)
    nil
  end

  def complete_room(room_id)
    return true unless room_id

    room = client.video.rooms(room_id)

    room.update(status: "completed") rescue true
  end

  def retrieve_in_progress_by_room_sid(room_id)
  end

  private

  def client
    @client ||= Twilio::REST::Client.new(ACCOUNT_SID, TWILIO_AUTH_TOKEN)
  end
end
