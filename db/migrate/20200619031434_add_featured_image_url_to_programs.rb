class AddFeaturedImageUrlToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :featured_image_url, :text
  end
end
