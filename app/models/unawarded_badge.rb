class UnawardedBadge < ApplicationRecord
  belongs_to :student
  belongs_to :badge
  belongs_to :lesson
  acts_as_tenant(:tenant)

  # validates_uniqueness_of :badge_id, scope: %i[student_id]

  def image_url
    badge&.image_url
  end
end
