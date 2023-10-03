class AddDemographicFieldsToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :gender, :string
    add_column :students, :ethncity, :string
    add_column :students, :age_range, :string
    add_column :students, :income, :string
  end
end
