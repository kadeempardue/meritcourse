class FormSubmission < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :form

  def username
    return nil if email.present?
    return nil unless last_name.present? && first_name.present?

    [last_name.gsub(/\s+/, ""), first_name.first].join
  end

  def fake_email
    email.presence || "#{SecureRandom.hex}@example.com"
  end
end
