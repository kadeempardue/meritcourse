class CreatePrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :description
      t.text :course_ids  # Comma Delimited
      t.text :concepts    # Comma Delimited
      t.text :outcomes    # Comma Delimited
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
