class Meritadmin::DashboardController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!
  helper_method :students, :courses, :lessons, :enrollments, :subject, :reviews

  def index
    @stripe_connect_account = StripeConnectAccount.find_by(tenant: @tenant)
    if @stripe_connect_account
      stripe_balance = Meritadmin::StripeService.new(@stripe_connect_account).get_balance
      @available_balance = (stripe_balance.available[0].amount / 100.0)
      @pending_balance = (stripe_balance.pending[0].amount / 100.0)
    end
  end

  private

  def students
    @students ||= ::Student.all
  end

  def courses
    @courses ||= ::Course.all
  end

  def lessons
    @lessons ||= courses.map(&:lessons).flatten
  end

  def enrollments
    @enrollments ||= ::Enrollment.all
  end

  def subject
    @subjects ||= ::Subject.all
  end

  def reviews
    @reviews ||= ::Review.all
  end
end
