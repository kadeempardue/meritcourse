class StripeProduct < ApplicationRecord
  has_many :stripe_prices
  acts_as_tenant(:tenant)
  belongs_to :stripe_connect_account
end
