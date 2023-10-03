class Enrollment < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :course
  belongs_to :student

  validates :enrollment_status, presence: true
  validates_uniqueness_of :course_id, scope: %i[student_id]

  # last_lesson_id_not_slug_cause_slug_can_change

  def active?
    enrollment_status == "Active"
  end

  def analytics
    self[:analytics].presence || {}
  end
end
