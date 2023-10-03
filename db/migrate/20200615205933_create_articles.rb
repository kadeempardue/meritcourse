class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :category, null: false
      t.string :featured_image
      t.string :body, null: false
      t.string :post_status
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
