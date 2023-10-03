class Meritadmin::StripeService
  def initialize(stripe_connect_account)
    raise "Stripe Integration Invalid" unless stripe_connect_account.present?
    @access_token = stripe_connect_account.access_token
    @stripe_user_id = stripe_connect_account.stripe_user_id
    @stripe_account = stripe_connect_account
  end

  def create_plan(plan)
    plan.stripe_connect_account = @stripe_account
    plan.stripe_product = create_stripe_product(plan)
    plan.stripe_price = create_stripe_price(plan)
    plan.save
  end

  def update_plan(plan, attrs)
    plan.assign_attributes(attrs.merge(stripe_connect_account: @stripe_account))
    plan.stripe_product = update_stripe_product(plan)
    plan.stripe_price = create_stripe_price(plan)
    plan.save
  end

  def get_balance
    Stripe::Balance.retrieve(api_key: @access_token, stripe_account: @stripe_user_id)
  end

  def express_link(redirect_url)
    account.login_links.create(redirect_url: redirect_url).url
  end

  private

  def account
    @account ||= Stripe::Account.retrieve(@stripe_user_id, { api_key: @access_token })
  end

  def create_stripe_product(plan)
    product = Stripe::Product.create(
        {
          name: plan.name,
          active: true,
          type: "service",
          unit_label: "membership"
        },
        {
          api_key: @access_token,
          stripe_account: @stripe_user_id
        }
      )

    StripeProduct.create({
      stripe_product_id: product.id,
      active: product.active,
      description: product.description,
      name: product.name,
      created_unix: product.created,
      updated_unix: product.updated,
      livemode: product.livemode,
      statement_descriptor: product.statement_descriptor,
      product_type: product.type,
      stripe_connect_account: @stripe_account
    })
  end

  def update_stripe_product(plan)
    stripe_product = plan.stripe_product
    Stripe::Product.update(stripe_product.stripe_product_id,
      {
        name: plan.name
      },
      {
        api_key: @access_token,
        stripe_account: @stripe_user_id
      }
    )

    stripe_product.update(name: plan.name, updated_unix: Time.now.to_i)
    stripe_product
  end

  def create_stripe_price(plan)
    opts = {
      unit_amount: (plan.amount.to_i*100),
      currency: plan.currency.downcase,
      product: plan.stripe_product.stripe_product_id,
    }

    opts[:recurring] = {
      interval: friendly_interval(plan.interval)
    } if !plan.lump_sum?

    price = Stripe::Price.create(
        opts,
        {
          api_key: @access_token,
          stripe_account: @stripe_user_id
        }
      )

    StripePrice.create({
      stripe_price_id: price.id,
      stripe_product: plan.stripe_product,
      active: price.active,
      currency: price.currency,
      recurring: price.recurring.to_h,
      price_type: price.type,
      unit_amount: price.unit_amount,
      billing_scheme: price.billing_scheme,
      created_unix: price.created,
      livemode: plan.stripe_product.livemode,
      stripe_connect_account: @stripe_account
    })
  end

  def friendly_interval(interval)
    case interval
    when "Monthly"
      "month"
    when "Yearly"
      "year"
    end
  end

  # @stripe_invoices = Stripe::Invoice.list({
  #   limit: 100,
  #   status: "paid",
  #   created: {
  #     gte: 10.year.ago.beginning_of_year.to_time.to_i
  #   }
  # }, {
  #   api_key: @stripe_connect_account.access_token,
  #   stripe_account: @stripe_connect_account.stripe_user_id
  # }).data.sum(&:amount_paid)
  #
  # @stripe_payouts = Stripe::Payout.list({
  #   limit: 100,
  #   status: "paid",
  #   arrival_date: {
  #     gte: 3.years.ago.beginning_of_year.to_time.to_i
  #   }
  # }, {
  #   api_key: @stripe_connect_account.access_token,
  #   stripe_account: @stripe_connect_account.stripe_user_id
  # }).data.sum(&:amount)

  # Stripe::Customer.list(
  #   {},
  #   {
  #     api_key: @stripe_connect_account.access_token,
  #     stripe_account: @stripe_connect_account.stripe_user_id
  #   }
  # )

end
