class AddEvenMoreFieldsForPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :feature_1_help_text, :text
    add_column :plans, :feature_2_help_text, :text
    add_column :plans, :feature_3_help_text, :text
    add_column :plans, :feature_4_help_text, :text
    add_column :plans, :feature_5_help_text, :text
  end
end
