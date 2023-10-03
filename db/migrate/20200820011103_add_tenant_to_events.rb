class AddTenantToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :tenant_id, :integer, index: true
  end
end
