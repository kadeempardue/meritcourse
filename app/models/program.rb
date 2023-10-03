class Program < ApplicationRecord
  acts_as_tenant(:tenant)

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name,        presence: true
  validates :description, presence: true
  # validates :course_plan, presence: true
  # validates :concepts,    presence: true
  # validates :outcomes,    presence: true

  default_scope -> { order("created_at DESC") }

  def featured_image_url
    uri = URI.parse(Cloudinary::Utils.cloudinary_url(super.presence)) rescue nil
    return super.presence unless uri

    uri.scheme = "https"
    uri.to_s
  end

  def self.find_all_from_subject(subject)
    # programs = all
    # courses = program.map(&:course)
    # subjects = courses.map(&:subject)
    # programs.select { |program| subjects.include? subject }
    []
  end
end
