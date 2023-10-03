class CreatePostmarkSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :postmark_settings do |t|
      t.string :postmark_confirmed
      t.string :postmark_domain_name
      t.integer :postmark_domain_id
      t.text :postmark_dkim_pending_host
      t.text :postmark_dkim_pending_text_value
      t.string :postmark_dkim_update_status
      t.string :postmark_return_path_domain, default: "pm-bounces"
      t.text :postmark_return_path_domain_cname_value
      t.boolean :postmark_return_path_domain_verified
      t.string :postmark_from_email
      t.string :postmark_from_name
      t.integer :postmark_sender_id
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
