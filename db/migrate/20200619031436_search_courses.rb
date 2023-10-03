class SearchCourses < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :courses, :name
    # DbTextSearch::FullText.add_index connection, :courses, :excerpt
    # DbTextSearch::FullText.add_index connection, :courses, :description
    DbTextSearch::FullText.add_index connection, :courses, :objectives
  end
end
