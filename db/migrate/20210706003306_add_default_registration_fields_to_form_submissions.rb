class AddDefaultRegistrationFieldsToFormSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :form_submissions, :first_name, :string
    add_column :form_submissions, :last_name, :string
    add_column :form_submissions, :email, :string
  end
end
