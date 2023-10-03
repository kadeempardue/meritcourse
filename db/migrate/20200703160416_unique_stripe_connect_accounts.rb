class UniqueStripeConnectAccounts < ActiveRecord::Migration[5.1]
  def change
    add_index :stripe_connect_accounts, :stripe_user_id, unique: true
  end
end
