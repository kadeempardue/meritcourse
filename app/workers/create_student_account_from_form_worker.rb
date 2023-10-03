class CreateStudentAccountFromFormWorker
  # include Sidekiq::Worker

  def perform(form, form_submission)
    ActsAsTenant.without_tenant do
      tenant = form.tenant
      first_name = form_submission.first_name
      last_name = form_submission.last_name
      email = form_submission.email.presence || form_submission.fake_email
      username = form_submission.username
      password = form.password_digest

      # firebase_user = firebase_service.create_user(email, password, tenant&.firebase_tenant_id)
      firebase_token = firebase_service.generate_custom_token_claim(tenant.firebase_tenant_id, username)
      now = Time.now
      Student.create({
        first_name: first_name,
        last_name: last_name,
        email: email,
        tos_agreement: true,
        tos_acceptance_date: DateTime.now,
        uuid: username,
        onboarding_complete: true,
        # firebase_refresh_token: firebase_user["refreshToken"],
        firebase_id_token: firebase_token,
        # firebase_issued_at: now.to_datetime,
        # firebase_expiration: (now + firebase_user["expiresIn"].to_i).to_datetime,
        tenant: tenant
      })
      true
    end
  end

  def firebase_service
    @firebase_service ||= FirebaseService.new
  end

  def saas_url(tenant)
    if Rails.env.production?
      tenant.subdomain == "NULL" || tenant.subdomain.blank? ? "https://#{tenant.domain}" : "https://#{tenant.subdomain}.#{tenant.domain}"
    else
      tenant.subdomain.blank? ? "http://#{tenant.domain}:3000" : "http://#{tenant.subdomain}.#{tenant.domain}:3000"
    end
  end
end
