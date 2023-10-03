class ChangeUpdatedOnStripePrices < ActiveRecord::Migration[5.1]
  def up
    remove_column :stripe_prices, :updated_unix
  end

  def down
  end
end
