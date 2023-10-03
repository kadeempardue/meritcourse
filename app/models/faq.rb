class Faq < ApplicationRecord
  acts_as_tenant(:tenant)
end
