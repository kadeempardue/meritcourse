class ZoomConfig < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :tenant
end
