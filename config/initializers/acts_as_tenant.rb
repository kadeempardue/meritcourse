require 'acts_as_tenant/sidekiq'

ActsAsTenant.configure do |config|
  config.require_tenant = true
end

# if Rails.env.development? && ActiveRecord::Base.connection.table_exists?("tenants")
  # ActsAsTenant.current_tenant = Tenant.first
# end
