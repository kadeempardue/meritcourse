class Meritadmin::HelpController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!
end
