class TwilioGroupRoom < ApplicationRecord
  belongs_to :lesson
  validates_presence_of :lesson
end
