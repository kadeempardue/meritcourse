class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.string :interval, null: false # one_time, monthly, annual
      t.integer :interval_count, null: false
      t.references :stripe_product, null: false # prod_ErVVtERGJJz2bj
      t.references :stripe_price, null: false # black
      t.references :stripe_connect_account, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
