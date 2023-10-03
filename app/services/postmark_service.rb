class PostmarkService
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  def initialize(tenant)
    @postmark_settings = tenant.postmark_setting
    raise "Postmark not set" unless @postmark_settings.present?
  end

  def send_reset_password_instructions(resource, opts = {})
    return unless resource.present?

    resource.reset_password_token = opts[:oob_code]
    resource.reset_password_token_date = DateTime.now
    resource.save

    deliver_password_reset_email(resource, opts)
  end

  def send_badge(resource, opts = {})
    return unless resource.present? || opts[:badge].present?

    deliver_badge_email(resource, opts)
  end

  def send_newsletter(opts = {})
    return unless opts.present?

    deliver_list_email(opts)
  end

  def send_invoice_paid_email(opts = {})
    return unless opts.present?

    deliver_invoice_paid_email(opts)
  end

  def send_invoice_failed_payment_email(opts = {})
    return unless opts.present?

    deliver_invoice_failed_payment_email(opts)
  end

  def send_payment_success_email(opts = {})
    return unless opts.present?

    deliver_payment_success_email(opts)
  end

  def send_daily_student_logins_email(opts = {})
    return unless opts.present?

    deliver_daily_student_logins_email(opts)
  end

  def send_date_range_student_logins_count_email(opts = {})
    return unless opts.present?

    deliver_date_range_student_logins_count_email(opts)
  end

  private

  def client
    @client ||= Postmark::ApiClient.new(ENV["POSTMARK_API_TOKEN"])
  end

  def from
    @postmark_settings.postmark_from_email
  end

  def tenant
    @postmark_settings.tenant
  end

  def setting
    tenant.setting || tenant.create_setting
  end

  def logo_url(root_url)
    logo_url = setting.logo_url
    logo_url = "#{root_url}#{logo_url}" if logo_url.starts_with?("/")
    logo_url
  end

  def primary_color
    "#111111"
  end

  def layout_opts(opts)
    {
      root_url: opts[:root_url],
      logo_url: logo_url(opts[:root_url]),
      primary_color: primary_color,
      year: Time.now.year,
      company_name: tenant&.name,
      company_address: "", # TODO
      company_city_state_zip: "", # TODO
    }
  end

  def deliver_password_reset_email(resource, opts)
    client.deliver_with_template({
      from: from,
      to: resource.email,
      template_alias: "password-reset",
      template_model: {
        name: resource.name,
        product_name: tenant&.name,
        action_url: "#{opts[:root_url]}/change_password?t=#{resource.reset_password_token}",
        support_url: "" # TODO
      }.merge(layout_opts(opts))
    })
  end

  def deliver_badge_email(resource, opts)
    client.deliver_with_template({
      from: from,
      to: resource.email,
      cc: opts[:cc],
      template_alias: "issue-badge",
      template_model: {
        name: resource.name,
        product_name: tenant&.name,
        lesson_name: opts[:lesson_name],
        badge_url: opts[:badge].image_url,
        support_url: "" # TODO
      }.merge(layout_opts(opts))
    })
  end

  def deliver_list_email(opts)
    client.deliver_with_template({
      from: from,
      to: opts[:email],
      bcc: from,
      template_alias: opts[:list_name],
      template_model: {
        name: opts[:first_name],
        content: I18n.t("#{tenant&.key}.settings.newsletter_content", default: ""),
        product_name: tenant&.name,
      }.merge(layout_opts(opts))
    })
  end

  def deliver_invoice_paid_email(opts)
    data = opts[:data]

    client.deliver_with_template({
      from: from,
      to: data[:customer_email],
      template_alias: "receipt",
      template_model: {
        invoice_number: data[:number],
        statement_descriptor: "#{tenant.name} Membership",
        paid_on: friendly_date(Time.at(data[:status_transitions][:paid_at])),
        pdf_invoice_url: data[:invoice_pdf],
        hosted_invoice_url: data[:hosted_invoice_url],
        line_charge_description: data[:lines][:data][0][:description],
        line_charge_amount: number_to_currency((data[:lines][:data][0][:amount] / 100), precision: 0),
        line_charge_period_start: friendly_date(Time.at(data[:lines][:data][0][:period][:start]), precision: 0),
        line_charge_period_end: friendly_date(Time.at(data[:lines][:data][0][:period][:end]), precision: 0),
        product_name: tenant&.name,
      }.merge(layout_opts(opts))
    })
  end

  def deliver_invoice_failed_payment_email(opts)
    data = opts[:data]
    customer = Student.find_by(membership_id: data[:customer])
    return unless customer.present?

    client.deliver_with_template({
      from: from,
      to: customer.email,
      template_alias: "failed-invoice-payment",
      template_model: {
        name: customer.name,
        invoice_number: data[:number],
        date: friendly_date(Time.now),
        next_payment_attempt_date: friendly_date(Time.at(data[:next_payment_attempt])),
        pdf_invoice_url: data[:invoice_pdf],
        hosted_invoice_url: data[:hosted_invoice_url],
        line_charge_description: data[:lines][:data][0][:description],
        line_charge_amount: number_to_currency((data[:lines][:data][0][:amount] / 100)),
        line_charge_period_start: friendly_date(data[:lines][:data][0][:period][:start]),
        line_charge_period_end: friendly_date(data[:lines][:data][0][:period][:end]),
        product_name: tenant&.name,
      }.merge(layout_opts(opts))
    })
  end

  def deliver_payment_success_email(opts)
    data = opts[:data]

    client.deliver_with_template({
      from: from,
      to: data[:customer_email],
      template_alias: "payment-success",
      template_model: {
        invoice_number: data[:number],
        statement_descriptor: "#{tenant.name} Membership",
        paid_on: friendly_date(Time.at(data[:status_transitions][:paid_at])),
        pdf_invoice_url: data[:invoice_pdf],
        hosted_invoice_url: data[:hosted_invoice_url],
        line_charge_description: data[:lines][:data][0][:description],
        line_charge_amount: number_to_currency((data[:lines][:data][0][:amount] / 100)),
        product_name: tenant&.name,
      }.merge(layout_opts(opts))
    })
  end

  def deliver_daily_student_logins_email(opts)
    client.deliver_with_template({
      from: from,
      bcc: opts[:admin_emails],
      template_alias: "daily-student-logins",
      template_model: {
        report_date: opts[:report_date],
        students: (opts[:students].presence || [{ name: "None" }]),
        product_name: tenant&.name,
      }.merge(layout_opts(opts))
    })
  end

  def deliver_date_range_student_logins_count_email(opts)
    client.deliver_with_template({
      from: from,
      bcc: opts[:admin_emails],
      template_alias: "student-logins-count",
      template_model: {
        start_date: opts[:start_date],
        end_date: opts[:end_date],
        students: (opts[:results].presence || [{ name: "None" }]),
        product_name: tenant&.name,
      }.merge(layout_opts(opts))
    })
  end

  # message_stream: ENV["POSTMARK_BROADCAST_ID"]
end
