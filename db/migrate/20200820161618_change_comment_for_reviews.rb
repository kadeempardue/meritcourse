class ChangeCommentForReviews < ActiveRecord::Migration[5.1]
  def change
    change_column :reviews, :comment, :text
  end
end
