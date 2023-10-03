class ChangePlanAccessToCourses < ActiveRecord::Migration[5.1]
  def change
    change_column :courses, :plan_access, :string
  end
end
