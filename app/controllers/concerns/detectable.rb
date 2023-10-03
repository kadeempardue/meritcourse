module Detectable
  extend ActiveSupport::Concern
  included do
    before_action :set_tenant
    set_current_tenant_through_filter
  end

  def set_tenant
    @tenant ||= request.env['Detectify-Entity']
    if @tenant.blank?
      @show_header = false
      @show_footer = false
      render template: "exception_handler/exceptions/no_tenant"
    end

    session[:tenant_id] = @tenant&.id if session[:tenant_id].blank? && @tenant&.present?
    set_current_tenant(@tenant)
  end
end
