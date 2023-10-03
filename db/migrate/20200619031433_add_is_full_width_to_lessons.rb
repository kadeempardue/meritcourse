class AddIsFullWidthToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :is_full_width, :boolean, null: false, default: false
  end
end
