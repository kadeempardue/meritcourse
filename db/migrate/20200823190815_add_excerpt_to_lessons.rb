class AddExcerptToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :excerpt, :text
  end
end
