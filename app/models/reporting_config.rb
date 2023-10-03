class ReportingConfig < ApplicationRecord
  acts_as_tenant(:tenant)
end
