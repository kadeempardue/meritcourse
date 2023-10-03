class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :article_comments
  alias_method :comments, :article_comments

  acts_as_tenant(:tenant)

  default_scope -> { order("created_at DESC") }

  scope :published, -> { where(post_status: "Published") }

  def featured_image
    uri = URI.parse(Cloudinary::Utils.cloudinary_url(super.presence)) rescue nil
    return super.presence unless uri

    uri.scheme = "https"
    uri.to_s
  end

  def draft?
    post_status == "Draft"
  end

  def published?
    post_status == "Published"
  end
end
