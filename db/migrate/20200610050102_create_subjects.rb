class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :icon_url
      t.string :is_preview, default: false
      t.string :description
      t.string :course_count
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
