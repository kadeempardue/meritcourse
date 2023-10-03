class FirebaseService
  API_KEY = ENV['GCP_API_KEY']
  GOOGLE_KID_URL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

  def generate_password_reset_link(email, ip_address, tenant_id)
    return {} unless email.present? && ip_address.present? && tenant_id.present?

    url = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=#{API_KEY}"
    resp = Faraday.post(url, { requestType: "PASSWORD_RESET", email: email, returnOobLink: true, userIp: ip_address, tenantId: tenant_id }.to_json, { "Content-Type" => "application/json", 'Authorization' => "Bearer #{generate_access_token}" })
    JSON.parse(resp.body)
  end

  def create_user(email, password, tenant_id)
    return unless email && password && tenant_id

    url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{API_KEY}"
    resp = Faraday.post(url, { email: email, password: password, emailVerified: true, tenantId: tenant_id }.to_json, { "Content-Type" => "application/json" })
    JSON.parse(resp.body)
  end

  def update_email(uuid, id_token, email, password, tenant_id)
    return unless uuid && id_token && (email || password) && tenant_id

    url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=#{API_KEY}"
    payload = { idToken: id_token, localId: uuid, tenantId: tenant_id, returnSecureToken: true }
    payload[:email] = email if email.present?
    payload[:password] = password if password.present?
    resp = Faraday.post(url, payload.to_json, { "Content-Type" => "application/json" })
    JSON.parse(resp.body)
  end

  def change_password(oobCode, password, tenant_id)
    url = "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=#{API_KEY}"
    resp = Faraday.post(url, { oobCode: oobCode, newPassword: password, tenantId: tenant_id }.to_json, "Content-Type" => "application/json")
    JSON.parse(resp.body)
  end

  def exchange_refresh_token(refresh_token, tenant_id)
    url = "https://securetoken.googleapis.com/v1/token?key=#{API_KEY}"
    resp = Faraday.post(url, { refresh_token: refresh_token, grant_type: "refresh_token", tenantId: tenant_id }.to_json, "Content-Type" => "application/json")
    JSON.parse(resp.body)
  end

  # We don't know how often Google rotates their certificates. So we pull on each request.
  # https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
  # It recommends checking the max-age property of the Cache-Control header on the endpoint to know when to rotate
  # but we don't do that here.
  def decode(token)
    certs = JSON.parse(Faraday.get(GOOGLE_KID_URL).body).values.map { |x| OpenSSL::X509::Certificate.new(x) }
    return { errors: 'no_valid_token' } unless token.present?
    data = {}
    certs.each do |cert|
      data = JWT.decode(token, cert.public_key, true, { algorithm: "RS256"  }).first rescue nil
      next if data.nil?

      exp_time = Time.at(data['exp'])
      data.merge({
        expiration_time: exp_time,
        seconds_left: (exp_time - Time.now)
      })
      break
    end
    data || raise("Token could not be decoded.")
  rescue => e
    { errors: e }
  end

  def generate_custom_token_claim(tenant_id, username = "hello")
    return unless tenant_id.present?

    certs = JSON.parse(Faraday.get(GOOGLE_KID_URL).body).values.map { |x| OpenSSL::X509::Certificate.new(x) }
    private_key_json_string = File.open("#{Rails.root}/config/firebase-#{ENV['RELEASE_STAGE']}.json").read
    data = ""

    certs.each do |cert|
      time_now = Time.now.to_i
      exp_time = 1.hour.from_now.to_i
      config = JSON.parse(private_key_json_string)

      data = JWT.encode({
        iss: config["client_email"],
        sub: config["client_email"],
        aud: "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
        exp: exp_time,
        iat: time_now,
        uid: username,
        tenant_id: tenant_id
        }, OpenSSL::PKey::RSA.new(config["private_key"]), "RS256") rescue nil
      next if data.nil?

      break
    end

    data
  end

  private

  def generate_access_token
    private_key_json_string = File.open("#{Rails.root}/config/firebase-#{ENV['RELEASE_STAGE']}.json").read
    @credentials = Google::Auth::DefaultCredentials.make_creds(
      json_key_io: StringIO.new(private_key_json_string),
      scope: %w(https://www.googleapis.com/auth/identitytoolkit https://www.googleapis.com/auth/cloud-platform)
    )
    @credentials.apply!({ 'Content-Type' => 'application/json' })
    @credentials.fetch_access_token!["access_token"]
  end
end
