class CreateStripeProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_products do |t|
      t.string :stripe_product_id, null: false
      t.boolean :active, null: false
      t.string :description, null: false
      t.string :name, null: false
      t.integer :created_unix, null: false
      t.integer :updated_unix, null: false
      t.boolean :livemode, null: false, default: !Rails.env.development?
      t.string :statement_descriptor, null: false
      t.string :product_type, null: false, default: "service"
      t.references :stripe_connect_account, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
