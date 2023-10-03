class AddJwtToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :auth0_access_token, :text
    add_column :students, :auth0_id_token, :text
    add_column :students, :auth0_issued_at, :datetime
    add_column :students, :auth0_expiration, :datetime
  end
end
