class ArticleComment < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :article
  belongs_to :student
end
