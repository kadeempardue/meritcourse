class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :profile_image
      t.string :title
      t.string :city
      t.string :state
      t.string :zip
      t.string :membership_id
      t.string :membership_subscription_id
      t.string :membership_interval
      t.string :membership_status
      t.boolean :tos_agreement, null: false, default: false
      t.string :reset_password_token
      t.datetime :reset_password_token_date
      t.string :uuid
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
