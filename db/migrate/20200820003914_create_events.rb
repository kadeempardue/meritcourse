class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.json :message, null: false
      t.timestamps
    end
  end
end
