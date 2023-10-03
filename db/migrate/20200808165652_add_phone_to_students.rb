class AddPhoneToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :phone_number, :string
  end
end
