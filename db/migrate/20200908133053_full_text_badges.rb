class FullTextBadges < ActiveRecord::Migration[5.1]
  def change
    DbTextSearch::FullText.add_index connection, :badges, :name
  end
end
