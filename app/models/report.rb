class Report < ApplicationRecord
  acts_as_tenant(:tenant)
end
