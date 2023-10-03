class Student < ApplicationRecord
  acts_as_tenant(:tenant)

  has_many :enrollments, dependent: :restrict_with_error
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :reviews,     dependent: :nullify
  has_many :awarded_badges,     dependent: :nullify
  belongs_to :current_plan, class_name: "Plan", foreign_key: "current_plan_id", optional: true

  validates :tos_agreement,       acceptance: true
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name,  presence: true, length: { minimum: 2, maximum: 50 }
  # REGEX: https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates
  validates :email,      presence: true, length: { maximum: 50 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_uniqueness_to_tenant %i[email]

  def self.dummy
    new({
      first_name: "Basic",
      last_name: "Student",
      email: "no@email.com",
      created_at: Time.now
    })
  end

  def update_firebase_token(opts)
    return false unless opts.present?
    return false unless opts[:firebase_refresh_token].present?
    return false unless opts[:firebase_id_token].present?
    return false unless opts[:firebase_issued_at].present?
    return false unless opts[:firebase_expiration].present?

    update(
      firebase_refresh_token: opts[:firebase_refresh_token],
      firebase_id_token: opts[:firebase_id_token],
      firebase_issued_at: opts[:firebase_issued_at],
      firebase_expiration: opts[:firebase_expiration],
    )
  end

  def name
    [first_name, last_name].join(" ")
  end

  def friendly_name
    "#{name} - #{email}"
  end

  def location
    "#{city + ', ' if city}#{state + ' ' if state}#{zip}"
  end

  def ethnicity
    ethncity
  end

  def token_expired?
    return true unless reset_password_token
    reset_password_token_date < 24.hours.ago
  end

  # These tokens are short lived. Generate them 30 minutes ahead of time to be safe.
  def firebase_token_expired?
    return true unless firebase_expiration
    firebase_expiration.localtime - 30.minutes < Time.now.localtime
  end

  # def membership_status
  #   self[:membership_status] || I18n.t("membership_statuses")[0]
  # end

  def profile_image
    uri = URI.parse(Cloudinary::Utils.cloudinary_url(super.presence, gravity: "faces", crop: "fill", width: 250, height: 250)) rescue nil
    return super.presence unless uri

    uri.scheme = "https"
    uri.to_s
  end
end
