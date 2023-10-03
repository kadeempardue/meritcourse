class Form < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_tenant(:tenant)
  has_many :form_submissions

  def esign?
    false
  end
end
