class AddIsLockedToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :is_locked, :boolean, default: false
    add_column :lessons, :is_archived, :boolean, default: false
  end
end
