class ChangeIntervalCountOnPlans < ActiveRecord::Migration[5.1]
  def up
    change_column :plans, :interval_count, :integer, null: true
  end

  def down
  end
end
