class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :featured_preview_video_url
      t.string :featured_preview_image_url
      t.boolean :is_preview, null: false, default: true
      t.string :level, null: false
      t.string :description
      t.string :excerpt
      t.string :objectives
      t.string :requirements
      t.references :subject
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
