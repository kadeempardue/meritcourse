class StripeConnectAccount < ApplicationRecord
  acts_as_tenant(:tenant)
  has_many :plans
end
