class CreateAwsFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :aws_files do |t|
      t.text :url, null: false
      t.text :key, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
