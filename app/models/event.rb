class Event < ApplicationRecord
  acts_as_tenant(:tenant)
end