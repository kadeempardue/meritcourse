class AddMessageTypeAndUuidToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :message_type, :string, null: false
    add_column :events, :uuid, :string
  end
end
