class AddFieldsToAwardedBadges < ActiveRecord::Migration[5.1]
  def change
    add_reference :awarded_badges, :lesson, index: true
    add_column :awarded_badges, :display_date, :datetime
  end
end
