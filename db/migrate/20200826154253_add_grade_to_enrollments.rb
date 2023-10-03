class AddGradeToEnrollments < ActiveRecord::Migration[5.1]
  def change
    add_column :enrollments, :analytics, :json # { lesson_id: grade, instructor_status }
    # add_column :enrollments, :instructor_status, :string, default: "Pending" # NP, Pass
    # add_column :enrollments, :badge_sent, :boolean, default: false
  end
end
