class Agenda < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :schedule
end
