class CreateAdminUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_users do |t|
      # t.string :reset_password_token
      # t.string :reset_password_token_date
      t.string :first_name, null: false
      t.string :last_name, null: false
      # t.string :uuid, null: false, unique: true
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
