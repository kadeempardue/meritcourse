class AddMoreSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :layout_for_lessons, :string, null: false, default: "fullpage" # fullpage, with_left_sidebar
  end
end
