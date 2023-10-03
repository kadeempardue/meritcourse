class Review < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :course
  belongs_to :student

  validates :comment, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :rating,  presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  default_scope -> { order("created_at DESC") }

  def author
    student || Student.dummy
  end

  def self.avg_ratings_for_course(course)
    calculate_average(course.reviews)
  end

  def self.avg_ratings_for_review_group(reviews)
    calculate_average(reviews)
  end

  def self.calculate_average(val)
    return 0.0 unless val.present? && val.count.positive?
    (val.sum(&:rating) / val.count).to_f.round(1)
  end

  def self.percentage_of(sub_count, total_count)
    return 0 unless sub_count.present? && total_count.present?
    ((sub_count.count / total_count.count.to_f) * 100) .to_i
  end
end
