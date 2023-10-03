class AddMoreFieldsForCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :plan_access, :text
  end
end
