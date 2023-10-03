class OnboardingController < ApplicationController
  before_action :authenticate_student!

  def index
    pusher_page
    @title = "Welcome to #{@tenant.name}"
    @show_header = false
  end
end
