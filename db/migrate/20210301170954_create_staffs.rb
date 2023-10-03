class CreateStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :staffs do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :profile_image
      t.string :title
      t.string :city
      t.string :state
      t.string :zip
      t.string :reset_password_token
      t.datetime :reset_password_token_date
      t.string :uuid
      t.integer :tenant_id, index: true
      t.text :firebase_refresh_token
      t.text :firebase_id_token
      t.datetime :firebase_issued_at
      t.datetime :firebase_expiration
      t.timestamps
    end
  end
end
