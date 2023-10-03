class CreateFormSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :form_submissions do |t|
      t.longtext :data, null: false
      t.longtext :submission
      t.references :form, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
