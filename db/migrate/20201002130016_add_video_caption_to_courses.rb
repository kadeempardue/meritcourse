class AddVideoCaptionToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :video_caption, :string
  end
end
