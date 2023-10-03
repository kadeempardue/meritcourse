class ChangeSubjectsIsPreview < ActiveRecord::Migration[5.1]
  def change
    change_column :subjects, :is_preview, :boolean
  end
end
