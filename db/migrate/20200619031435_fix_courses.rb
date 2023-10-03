class FixCourses < ActiveRecord::Migration[5.1]
  def change
    change_column :courses, :description, :text
    change_column :courses, :excerpt, :text
    change_column :courses, :objectives, :text
    change_column :courses, :requirements, :text
  end
end
