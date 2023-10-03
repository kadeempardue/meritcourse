class AddDefaultToArticles < ActiveRecord::Migration[5.1]
  def change
    change_column_default :articles, :post_status, 'Draft'
  end
end
