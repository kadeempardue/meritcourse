class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :report_type, null: false
      t.text :report_file, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
