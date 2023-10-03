class AddRegisterAccountToForms < ActiveRecord::Migration[5.1]
  def change
    add_column :forms, :register_account, :boolean, default: false, null: false
  end
end
