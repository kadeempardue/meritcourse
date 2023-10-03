class AddReferenceToTenantForAwardedBadges < ActiveRecord::Migration[5.1]
  def change
    add_reference :awarded_badges, :tenant, index: true
  end
end
