class ChangeNullOnDescriptionStripeProducts < ActiveRecord::Migration[5.1]
  def up
    change_column :stripe_products, :description, :text, null: true
    change_column :stripe_products, :statement_descriptor, :text, null: true
  end

  def down
    change_column :stripe_products, :description, :text, null: false
    change_column :stripe_products, :statement_descriptor, :text, null: false
  end
end
