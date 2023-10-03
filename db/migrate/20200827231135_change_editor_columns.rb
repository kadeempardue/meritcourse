class ChangeEditorColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :courses, :excerpt, :text, limit: 16.megabytes - 1
    change_column :courses, :description, :text, limit: 16.megabytes - 1
    change_column :courses, :requirements, :text, limit: 16.megabytes - 1
    change_column :courses, :objectives, :text, limit: 16.megabytes - 1

    change_column :lessons, :excerpt, :text, limit: 16.megabytes - 1
    change_column :lessons, :handouts, :text, limit: 16.megabytes - 1
  end
end
