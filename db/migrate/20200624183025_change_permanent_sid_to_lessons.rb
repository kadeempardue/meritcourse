class ChangePermanentSidToLessons < ActiveRecord::Migration[5.1]
  def change
    change_column :lessons, :permanent_sid, :string, null: true
  end
end
