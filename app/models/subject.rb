class Subject < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_tenant(:tenant)

  has_many :courses

  default_scope -> { order("created_at DESC") }

  def icon_url
    uri = URI.parse(Cloudinary::Utils.cloudinary_url(super.presence)) rescue nil
    return super.presence unless uri

    uri.scheme = "https"
    uri.to_s
  end

  def course_count
    courses.count
  end
end
