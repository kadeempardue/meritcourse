class Course < ApplicationRecord
  include Friendable

  acts_as_tenant(:tenant)

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :subject
  has_many   :lessons
  has_many   :enrollments, dependent: :restrict_with_error
  has_many   :reviews,     dependent: :nullify

  validates :name,  presence: true, length: { minimum: 2, maximum: 255 }
  # validates :featured_preview_video_url, length: { minimum: 2, maximum: 255 }
  # validates :featured_preview_image_url, length: { minimum: 2, maximum: 255 }
  # validates :level, presence: true, inclusion: { in: I18n.t("levels") }
  validates :subject_id, presence: true

  default_scope -> { order("created_at DESC") }
  scope :archived, -> { where(archived: true) }
  scope :not_archived, -> { where(archived: false) }

  def accessible_for_student?(student)
    beginner? ? accessible_for_any_student?(student) : accessible_for_paid_student?(student)
  end

  def avg_rating
    Review.avg_ratings_for_course(self).to_s
  end

  def num_of_enrollments
    enrollments.count.to_s
  end

  def enrolled_students
    enrollments.map(&:student).flatten.compact
  end

  def featured_preview_image_url
    uri = URI.parse(Cloudinary::Utils.cloudinary_url(super.presence)) rescue nil
    return super.presence unless uri

    uri.scheme = "https"
    uri.to_s
  end

  def total_lesson_duration
    lessons.sum(&:duration)
  end

  def total_duration
    total_lesson_duration
  end

  def full_total_duration
    friendly_full_duration_for(total_lesson_duration)
  end

  def beginner?
    level == "Beginner"
  end

  def accessible_for_any_student?(student)
    true
  end

  def accessible_for_paid_student?(student)
    student.black_plan? || student.gold_plan?
  end

  def self.group_all_reviews_by_threshold(courses, threshold)
    courses.map do |course|
      course.group_reviews_by_threshold(threshold)
    end.flatten
  end

  def self.all_avg_rating
    courses = Course.all
    courses = courses.select { |course| course.reviews.present? }
    return 0.0 unless courses.present?
    4.9 #(courses.sum(&:avg_rating).to_f / courses.count).to_f.round(1)
  end

  def lesson_modules
    lessons.group_by(&:module_name)
  end

  def group_reviews_by_threshold(threshold)
    reviews.select do |review|
      review.rating <= threshold + 0.9 && review.rating > threshold - 0.1
    end
  end

  def featured_preview_video_url
    orig = super
    return nil unless orig.present?
    "#{orig}?exp=#{exp}&sig=#{signature(orig, exp)}"
  end

  def is_scheduled?
    lessons.any? { |lesson| lesson.is_scheduled? }
  end

  private

  def exp
    @exp ||= 1.hour.from_now.to_i
  end

  def signature(orig, exp)
    content_path = orig.split('.com/')[1]
    secret = ENV['JWPLAYER_SECRET_KEY']
    Digest::MD5.hexdigest("#{content_path}:#{exp}:#{secret}")
  end
end
