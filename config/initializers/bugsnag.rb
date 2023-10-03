unless Rails.env.development?
  Bugsnag.configure do |config|
    config.api_key = ENV["BUGSNAG_API_KEY"]
    config.app_version = "arnold-1.0.0"
    config.release_stage = ENV["RELEASE_STAGE"]
    config.notify_release_stages = ["production", "staging"]
  end
end
