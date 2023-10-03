class AddColorsToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :quadrant_color, :string
    add_column :settings, :quaternary_color, :string
    add_column :settings, :quinary_color, :string
    add_column :settings, :senary_color, :string
    add_column :settings, :septenary_color, :string
    add_column :settings, :octonary_color, :string
    add_column :settings, :nonary_color, :string
    add_column :settings, :denary_color, :string
    add_column :settings, :undenary_color, :string
    add_column :settings, :duodenary_color, :string
    add_column :settings, :ternidenary_color, :string
  end
end
