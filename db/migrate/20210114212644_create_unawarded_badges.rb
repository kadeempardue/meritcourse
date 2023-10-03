class CreateUnawardedBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :unawarded_badges do |t|
      t.references :student, null: false
      t.references :badge, null: false
      t.references :lesson, index: true
      t.references :tenant, index: true
      t.datetime :display_date
      t.timestamps
    end
  end
end
