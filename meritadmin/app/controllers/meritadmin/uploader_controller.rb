class Meritadmin::UploaderController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!, only: %w(token)

  def token
    render html: nil
  end

  def file_upload

    render json: { message: "Success" }
  end
end
