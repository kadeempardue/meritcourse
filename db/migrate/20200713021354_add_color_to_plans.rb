class AddColorToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :color, :string
    add_column :plans, :recommended, :boolean, default: false, null: false
    add_column :plans, :order, :integer
  end
end
