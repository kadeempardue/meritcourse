class Plan < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :stripe_connect_account
  belongs_to :stripe_product
  belongs_to :stripe_price
  has_many :students, class_name: "Student", foreign_key: "current_plan_id"

  def lump_sum?
    interval == "Lump Sum"
  end

  def monthly?
    interval == "Monthly"
  end

  def yearly?
    interval == "Yearly"
  end

  def free?
    amount.to_i == 0
  end

  def paid?
    !free?
  end

  def friendly_amount
    amount / 100
  end

  def friendly_interval
    return "" if free?
    return " / mo" if monthly?
    " / yr" if yearly?
  end

  def has_features?
    feature_1.present? || feature_2.present? || feature_3.present? || feature_4.present? || feature_5.present?
  end
end
