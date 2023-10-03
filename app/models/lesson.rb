class Lesson < ApplicationRecord
  include Friendable

  acts_as_tenant(:tenant)

  belongs_to :course
  has_many :schedules
  has_many :awarded_badges
  accepts_nested_attributes_for :schedules

  validates :name,          presence: true, length: { minimum: 2, maximum: 255 }
  validates :module_name,   presence: true
  validates :lesson_type,   presence: true

  belongs_to :host, class_name: "Staff", foreign_key: "host_id", optional: true

  def ordered_lessons
    @ordered_lessons ||= []
    course.lesson_modules&.each do |lesson_module, lessons|
      @ordered_lessons << lessons
    end
    @ordered_lessons.flatten!.compact!
    @ordered_lessons
  end

  def next
    i = ordered_lessons.find_index(self)
    ordered_lessons[i + 1] if (i + 1).positive?
  end

  def prev
    i = ordered_lessons.find_index(self)
    ordered_lessons[i - 1] if i - 1 >= 0
  end

  def schedules_in_progress
    time_now = Time.now

    schedules.select do |schedule|
      within_start_bounds = (schedule.start_datetime - 15.minutes) < time_now
      within_end_bounds = schedule.end_datetime > time_now || schedule.end_datetime == time_now.beginning_of_day

      within_start_bounds && within_end_bounds
    end
  end

  def locked?
    is_locked
  end

  def lecture?
    lesson_type == 'Lecture'
  end

  def project?
    lesson_type == 'Project'
  end

  def project?
    lesson_type == 'Project'
  end

  def assessment?
    lesson_type == 'Assessment'
  end

  def interactive_activity?
    lesson_type == 'Interactive Activity'
  end

  def video?
    lesson_type == 'Video'
  end

  def duration
    self[:duration] || 0
  end

  def is_scheduled?
    return true if is_livestream?
    super
  end

  # def image_url
  #   uri = URI.parse(Cloudinary::Utils.cloudinary_url(super)) rescue nil
  #   return super.presence unless uri
  #
  #   uri.scheme = "https"
  #   uri.to_s
  # end

  def unique_livestream_name(tenant_key)
    return "" unless is_livestream?
    Digest::SHA256.hexdigest "#{tenant_key}-lesson-#{id}"
  end
end
