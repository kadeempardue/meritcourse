class CreateMarketingLists < ActiveRecord::Migration[5.1]
  def change
    create_table :marketing_lists do |t|
      t.string :first_name
      t.string :email, null: false
      t.string :list_name, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
