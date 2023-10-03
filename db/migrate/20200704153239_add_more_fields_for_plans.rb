class AddMoreFieldsForPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :feature_1, :string
    add_column :plans, :feature_2, :string
    add_column :plans, :feature_3, :string
    add_column :plans, :feature_4, :string
    add_column :plans, :feature_5, :string
  end
end
