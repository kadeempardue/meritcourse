class PostmarkSetting < ApplicationRecord
  acts_as_tenant(:tenant)
end
