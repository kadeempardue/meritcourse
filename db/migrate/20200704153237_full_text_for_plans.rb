class FullTextForPlans < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :plans, :name
  end
end
