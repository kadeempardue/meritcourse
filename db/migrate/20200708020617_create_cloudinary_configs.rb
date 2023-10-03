class CreateCloudinaryConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :cloudinary_configs do |t|
      t.text :folder_name, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
