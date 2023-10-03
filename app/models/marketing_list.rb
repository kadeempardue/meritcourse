class MarketingList < ApplicationRecord
  acts_as_tenant(:tenant)

  validates_presence_of :email, :list_name
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
