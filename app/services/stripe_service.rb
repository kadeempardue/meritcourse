class StripeService
  def initialize(tenant)
    @tenant = tenant
    @stripe_connect_account = tenant&.stripe_connect_account
    raise "Stripe Integration Invalid" unless @stripe_connect_account.present?

    @access_token = @stripe_connect_account.access_token
    @stripe_user_id = @stripe_connect_account.stripe_user_id
  end

  # def update_customer(customer_id, opts = {})
  #   Stripe::Customer.update(customer_id, customer_data(opts).merge({
  #     description: "Student (Re-Enrolled) | #{opts[:email]}"
  #   }))
  # end

  def create_customer(opts = {})
    return false unless opts.present? && opts[:email].present?
    @stripe_customer ||= Stripe::Customer.create(customer_data(opts).merge(email: opts[:email]), {
      api_key: @access_token,
      stripe_account: @stripe_user_id
    })
  rescue => e
    msg = "StripeService#create_customer could not be created: #{e.class.name} #{e.message}"
    Bugsnag.notify(msg) if Rails.env.production?
  end

  def create_subscription(opts = {})
    return false unless @stripe_customer
    plan = Plan.find(opts[:plan_id]) rescue nil

    return false unless plan.present?
    return false unless plan.stripe_price.present?

    @subscription = Stripe::Subscription.create({
      customer: @stripe_customer.id,
      items: [
        { price: plan.stripe_price.stripe_price_id },
      ],
      expand: ["latest_invoice.payment_intent"],
      application_fee_percent: 10
    }, {
      api_key: @access_token,
      stripe_account: @stripe_user_id
    })
  rescue => e
    msg = "StripeService#create_subscription could not be created: #{e.class.name} #{e.message}"
    Bugsnag.notify(msg) if Rails.env.production?
  end

  def create_customer_with_subscription(opts = {})
    create_customer(opts)
    create_subscription(opts)

    [@stripe_customer, @subscription]
  end

  def handle_webhook_response(type, opts = {})
    Event.create(message: opts[:data], message_type: type)

    case type
    when "customer.subscription.created"
    when "customer.source.created"
    when "customer.card.created"
    when "customer.bank_account.created"
    when "payment_intent.created"
    when "payment_intent.payment_failed"
      # opts[:postmark_service].send_payment_failed_email(opts[:data], opts)
    when "payment_intent.succeeded"
      # opts[:postmark_service].send_payment_success_email(opts)
    when "price.created"
    when "plan.created"
    when "customer.subscription.updated"
    when "payout.updated"
    when "payout.canceled"
    when "customer.subscription.deleted"
    when "customer.subscription.created"
    when "invoice.upcoming"
    when "payout.created"
    when "transfer.failed"
    when "transfer.paid"
    when "transfer.created"
    when "payout.failed"
    when "payout.paid"
    when "invoice.payment_action_required"
    when "invoice.payment_failed"
      #  opts[:postmark_service].send_invoice_failed_payment_email(opts)
    when "invoice.paid"
      opts[:postmark_service].send_invoice_paid_email(opts)
    when "invoice.created"
    when "customer.created"
    when "charge.refund.updated"
    when "charge.updated"
    when "charge.succeeded"
    when "charge.refunded"
    when "charge.pending"
    when "charge.failed"
    when "charge.expired"
    when "charge.captured"
    when "capability.updated"
    when "account.external_account.updated"
    when "account.external_account.deleted"
    when "account.external_account.created"
    when "account.application.deauthorized"
    when "account.application.authorized"
    when "account.updated"
    when "balance.available"
    when "application_fee.refund.updated"
    when "application_fee.refunded"
    when "application_fee.created"
    else
      msg = "StripeService#handle_webhook_response could not handle type: #{type} #{data}"
      Bugsnag.notify(msg) if Rails.env.production?
    end
  end

  private

  def customer_data(opts = {})
    {
      description: "Student | #{opts[:email]}",
      source: opts[:source],
      invoice_prefix: SecureRandom.hex(6).upcase,
      metadata: {
        source: "WEB"
      }
    }
  end
end
