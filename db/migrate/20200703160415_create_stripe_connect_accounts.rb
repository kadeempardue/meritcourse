class CreateStripeConnectAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_connect_accounts do |t|
      t.string :token_type, nil: false
      t.string :stripe_publishable_key, nil: false
      t.string :scope, nil: false
      t.boolean :livemode, nil: false
      t.string :stripe_user_id, nil: false
      t.string :refresh_token, nil: false
      t.string :access_token, nil: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
