class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :module_name
      t.integer :duration
      t.boolean :is_preview, default: true, null: false
      t.string :lesson_type
      t.string :video_url
      t.string :image_url
      t.string :handouts
      t.references :course
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
