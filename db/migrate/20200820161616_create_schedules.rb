class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.integer :join_window, null: false, default: 15
      t.references :lesson, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
