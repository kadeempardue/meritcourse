class CreateArticleComments < ActiveRecord::Migration[5.1]
  def change
    create_table :article_comments do |t|
      t.references :article, null: false
      t.references :student, null: false
      t.references :comment
      t.text :comment, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
