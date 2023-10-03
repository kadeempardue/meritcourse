class AddDefaultRegistrationPasswordToForms < ActiveRecord::Migration[5.1]
  def change
    add_column :forms, :password_digest, :string
  end
end
