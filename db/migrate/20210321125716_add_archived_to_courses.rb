class AddArchivedToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :archived, :boolean, default: false, null: false
  end
end
