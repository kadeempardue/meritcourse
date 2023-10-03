class AddPermanentSidToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :permanent_sid, :string, null: false
  end
end
