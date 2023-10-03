class FullTextFaqs < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :faqs, :name
  end
end
