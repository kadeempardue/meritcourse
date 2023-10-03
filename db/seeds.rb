ActsAsTenant.without_tenant do
  tenant = Tenant.create(
    name: "Demo",
    subdomain: nil,
    domain: "localhost",
    key: "sn",
    firebase_tenant_id: "mw3057e6b9e0-2pq8w",
  )

  tenant.create_setting(
    layout_for_lessons: "with_left_sidebar",
    sign_up_key: "helloworld",
    is_membership_portal: false,
  )

  tenant.create_postmark_setting(
    postmark_confirmed: "1",
    postmark_domain_name: "meritworks.com",
    postmark_domain_id: 1688264,
    postmark_dkim_pending_host: "20200621170638pm._domainkey.meritworks.com",
    postmark_dkim_pending_text_value:
     "k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbCmRY8dFHx30znUM+2tWJs2GorO8sXoWA4XM3vbN3ysxLsnoN8ZhOc5vngms3mF7xS8ThtbXtPiFO6VAeufxKQll0ihd3c6MSQFrGzo0S9nbtIXwe/ksVn5w5C4zat82Sr67OLG/czugCwr4kv3rQj+S3hyhcDEmGGp79NtkhswIDAQAB",
    postmark_dkim_update_status: "Verified",
    postmark_return_path_domain: "pm-bounces.meritworks.com",
    postmark_return_path_domain_cname_value: "pm.mtasv.net",
    postmark_return_path_domain_verified: true,
    postmark_from_email: "support@meritworks.com",
    postmark_from_name: "MeritWorks Support",
    postmark_sender_id: 2875857,
  )

  tenant.create_stripe_connect_account(
    token_type: "bearer",
    stripe_publishable_key: "pk_test_51NFU3TIsdXCc0S6Fo687xgFtouXLtKffWNzChJh6mBNjmppUFXBVYKgrobmDcIxz8Vx5IaCMav1i2wirKV5HohBL00rH7BWi29",
    scope: "express",
    livemode: false,
    stripe_user_id: "acct_1NFU3TIsdXCc0S6F",
    refresh_token: "rt_O1X9DnByppXKWBN8CMKK39O50P4QaQeah4q0eebBmkWKKEwd",
    access_token: "sk_test_51NFU3TIsdXCc0S6F9TbEK5IBySLjSZA59wOQVS3bMsXa2T39vSmRFIqxKCOrPHZ2bxc8mKoWdH6XxtBpOEND9vRm00XKnGYxEF",
  )
end
