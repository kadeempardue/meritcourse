class CreateTwilioGroupRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :twilio_group_rooms do |t|
      t.string :unique_name, unique: true
      t.text :account_sid
      t.text :sid, unique: true
      t.string :status
      t.boolean :enable_turn, null: false, default: true
      t.datetime :date_created
      t.datetime :date_updated
      t.text :status_callback
      t.string :status_callback_method
      t.datetime :end_time
      t.text :duration
      t.boolean :record_participants_on_connect, null: false, default: true
      t.text :video_codecs, null: false
      t.text :links
      t.text :url, null: false
      t.references :lesson
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
