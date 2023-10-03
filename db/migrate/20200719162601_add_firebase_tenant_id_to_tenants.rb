class AddFirebaseTenantIdToTenants < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :firebase_tenant_id, :string
  end
end
