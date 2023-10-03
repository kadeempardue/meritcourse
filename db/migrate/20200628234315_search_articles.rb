class SearchArticles < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :articles, :title
    DbTextSearch::FullText.add_index connection, :articles, :category
    DbTextSearch::FullText.add_index connection, :articles, :body
  end
end
