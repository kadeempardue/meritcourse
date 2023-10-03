class AddIsScheduledToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :is_scheduled, :boolean, null: false, default: false
  end
end
