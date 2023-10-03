class DeleteZoomConfigs < ActiveRecord::Migration[5.1]
  def change
    drop_table :zoom_configs
  end
end
