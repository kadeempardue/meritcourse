class ChangeCoursesIsPreview < ActiveRecord::Migration[5.1]
  def change
    change_column :courses, :is_preview, :boolean
  end
end
