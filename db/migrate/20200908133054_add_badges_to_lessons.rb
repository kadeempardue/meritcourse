class AddBadgesToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :badges, :text
  end
end
