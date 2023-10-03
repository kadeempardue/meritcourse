class CreateStripePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_prices do |t|
      t.string :stripe_price_id, null: false
      t.boolean :active, null: false
      t.string :currency, null: false
      t.string :nickname, null: false
      t.text :recurring, null: false
      t.string :price_type, null: false # one_time, recurring
      t.integer :unit_amount, null: false
      t.string :billing_scheme, null: false
      t.integer :created_unix, null: false
      t.integer :updated_unix, null: false
      t.boolean :livemode, null: false, default: !Rails.env.development?
      t.references :product, null: false # prod_ErVVtERGJJz2bj
      t.references :stripe_connect_account, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
