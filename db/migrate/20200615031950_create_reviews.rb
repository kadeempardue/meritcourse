class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :comment, null: false
      t.float :rating, null: false
      t.references :course
      t.references :student
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
