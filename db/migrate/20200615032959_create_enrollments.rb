class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.datetime :enrollment_date, null: false
      t.string :enrollment_status, null: false
      t.references :course
      t.references :student
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
