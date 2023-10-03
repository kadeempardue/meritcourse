class Schedule < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :lesson
  has_one :agenda

  def start_time
    start_datetime
  end

  def end_time
    end_datetime
  end
end
