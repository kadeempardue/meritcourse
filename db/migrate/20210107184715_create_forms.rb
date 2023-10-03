class CreateForms < ActiveRecord::Migration[5.1]
  def change
    create_table :forms do |t|
      t.string :slug, null: false, unique: true
      t.string :name, null: false
      t.longtext :data, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
