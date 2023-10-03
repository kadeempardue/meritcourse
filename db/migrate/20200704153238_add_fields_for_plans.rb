class AddFieldsForPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :excerpt, :string
    add_column :plans, :description, :text
  end
end
