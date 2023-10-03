class AddIsLivestreamToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :is_livestream, :boolean, null: false, default: false
  end
end
