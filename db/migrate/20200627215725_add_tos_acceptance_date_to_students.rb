class AddTosAcceptanceDateToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :tos_acceptance_date, :datetime
  end
end
