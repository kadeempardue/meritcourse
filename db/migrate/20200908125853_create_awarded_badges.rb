class CreateAwardedBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :awarded_badges do |t|
      t.references :student, null: false
      t.references :badge, null: false
      t.timestamps
    end
  end
end
