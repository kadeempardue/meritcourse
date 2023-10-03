class CreateZoomConfig < ActiveRecord::Migration[5.1]
  def change
    create_table :zoom_configs do |t|
      t.string :api_key
      t.string :api_secret
      t.string :default_meeting_room_number
      t.string :default_meeting_room_password
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
