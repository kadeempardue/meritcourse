class SearchSubjects < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :subjects, :name
    DbTextSearch::FullText.add_index connection, :subjects, :description
  end
end
