class ChangeBodyColumnOnArticles < ActiveRecord::Migration[5.1]
  def change
    change_column :articles, :body, :longtext
  end
end
