class CreateReportingConfig < ActiveRecord::Migration[5.1]
  def change
    create_table :reporting_configs do |t|
      t.string :email, null: false
      t.string :email_type, null: false
      t.integer :tenant_id, index: true
    end
  end
end
