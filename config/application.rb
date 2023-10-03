require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Meritcourse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.railties_order = [Meritadmin::Engine, :main_app, :all]

    config.time_zone = 'Eastern Time (US & Canada)'
    config.beginning_of_week = :sunday

    config.action_mailer.delivery_method = :postmark

    config.exception_handler = {
      # dev: Rails.env.development?,
      exceptions: {
        all: { layout: "application" }
      }
    }

    # config.action_mailer.postmark_settings = { :api_token => Rails.application.secrets.postmark_api_token }
  end
end
