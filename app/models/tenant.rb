class Tenant < ApplicationRecord
  has_one :setting
  has_one :stripe_connect_account
  has_one :postmark_setting
  has_many :forms
  has_many :reporting_configs
  has_many :plans
  has_one :cloudinary_config

  def base_url
    URI::HTTP.build(protocol: protocol, host: host, port: port).to_s
  end

  def host
    return domain unless (subdomain.present? && subdomain != "NULL")

    "#{subdomain}.#{domain}"
  end

  def port
    return nil unless Rails.env.development?

    "3000"
  end

  def protocol
    return "https" if Rails.env.production?

    "http"
  end
end
