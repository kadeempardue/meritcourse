class CreateFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :faqs do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
