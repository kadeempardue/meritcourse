class SearchPrograms < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :programs, :name
    DbTextSearch::FullText.add_index connection, :programs, :description
    DbTextSearch::FullText.add_index connection, :programs, :concepts
  end
end
