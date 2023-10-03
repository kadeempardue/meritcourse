class ChangeProductIdOnStripePrices < ActiveRecord::Migration[5.1]
  def up
    add_column :stripe_prices, :stripe_product_id, :text, null: true
    remove_column :stripe_prices, :product_id
  end

  def down
    remove_column :stripe_prices, :stripe_product_id
    add_column :stripe_prices, :product_id, :text, null: true
  end
end
