class ChangeAuth0ToFirebaseForStudents < ActiveRecord::Migration[5.1]
  def change
    rename_column :students, :auth0_access_token, :firebase_refresh_token
    rename_column :students, :auth0_id_token, :firebase_id_token
    rename_column :students, :auth0_issued_at, :firebase_issued_at
    rename_column :students, :auth0_expiration, :firebase_expiration
  end
end
