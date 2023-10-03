class ChangeNicknameOnStripePrices < ActiveRecord::Migration[5.1]
  def up
    remove_column :stripe_prices, :nickname
  end

  def down
    add_column :stripe_prices, :nickname, :text, null: true
  end
end
