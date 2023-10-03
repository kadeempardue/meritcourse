class Badge < ApplicationRecord
  acts_as_tenant(:tenant)
  has_many :awarded_badges, dependent: :nullify
  has_many :unawarded_badges, dependent: :nullify
  validates_presence_of :name, :earning_criteria, :image_url

  def image_url
    uri = URI.parse(Cloudinary::Utils.cloudinary_url(super.presence)) rescue nil
    return super.presence unless uri

    uri.scheme = "https"
    uri.to_s
  end
end
