class StripePrice < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :stripe_connect_account
  belongs_to :stripe_product, class_name: "StripeProduct", foreign_key: "stripe_product_id"
end
