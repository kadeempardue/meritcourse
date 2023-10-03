class SearchStudents < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :students, :email
    DbTextSearch::FullText.add_index connection, :students, :first_name
    DbTextSearch::FullText.add_index connection, :students, :last_name
  end
end
