class ProfilesController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_student_or_staff!

  def index
    pusher_page
    @title = "My Profile"
  end

  def show
    @user = Student.find_by(uuid: params[:uuid]) || Staff.find_by(uuid: params[:uuid])

    respond_to do |format|
      format.json  { render json: { name: @user.name, profile_image: avatar_helper(@user)  } }
    end
  end

  def update
    pusher_page
    if current_student_or_staff&.update(whitelisted_params)
      if whitelisted_params[:email].present?
        firebase_service.update_email(whitelisted_params[:email], @tenant.firebase_tenant_id)
      end
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', current_student_or_staff.id)

      if params[:redirect].present?
        return redirect_to params[:redirect]
      else
        return redirect_to profile_path
      end
    end

    flash[:error] = t("messages.failed_save")
    redirect_to profile_path
  end

  private

  def whitelisted_params
    params.require(:student).permit(:first_name, :last_name, :profile_image, :title, :phone_number, :city, :state, :zip, :age_range, :ethncity, :gender, :income, :onboarding_complete) rescue {}
  end
end
