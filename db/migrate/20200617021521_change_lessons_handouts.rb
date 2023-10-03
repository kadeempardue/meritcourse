class ChangeLessonsHandouts < ActiveRecord::Migration[5.1]
  def change
    change_column :lessons, :handouts, :text
  end
end
