class CreateBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.string :course_name
      t.string :lesson_name
      t.string :lesson_level
      t.string :issued_by
      t.text :description
      t.text :skills
      t.text :earning_criteria, null: false
      t.text :image_url, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
