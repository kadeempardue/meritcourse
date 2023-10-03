class AddInstagramHandleToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :social_media_instagram_handle, :string
  end
end
