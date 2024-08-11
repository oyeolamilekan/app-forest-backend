class ProcessFundJob < ApplicationJob
  queue_as :default

  def perform(args)
    @args = args
    process_fund
  end

  private

  def process_fund
    fetch_product
    shorten_repo_link
    fetch_github_integration
    add_user_to_repo
    create_customer
    create_invoice
  rescue StandardError => e
    # Log the error and potentially notify administrators
    Rails.logger.error("ProcessFundJob failed: #{e.message}")
    # You might want to re-raise the error or handle it differently depending on your needs
  end

  def fetch_product
    status, @product = Products::FetchProduct.call(product_attribute: { public_id: @args[:product_id] })
    raise "Failed to fetch product" unless status == :success
  end

  def shorten_repo_link
    status, @repo_name = Utils::RepoLink.shorten(@product.repo_link)
    raise "Failed to shorten repo link" unless status == :success
  end

  def fetch_github_integration
    status, @github_integration = Integrations::FetchIntegration.call(
      store_slug: @args[:store_slug],
      provider_id: Integration::GITHUB
    )
    raise "Failed to fetch GitHub integration" unless status == :success
  end

  def add_user_to_repo
    status, _ = Utils::AddUserToRepo.call(
      repo: @repo_name,
      username: @args[:github_username],
      permission: Integration::PULL_PERMISSION,
      access_token: @github_integration.key
    )
    raise "Failed to add user to repo" unless status == :success
  end

  def create_customer
    customer_attributes = {
      name: @args[:name],
      email: @args[:email],
      github_username: @args[:github_username],
      store_id: @args[:store_id]
    }
    status, @customer = Customers::CreateCustomer.call(customer_attributes: customer_attributes)
    raise "Failed to create customer" unless status == :success
  end

  def create_invoice
    invoice_attributes = {
      quantity: 1,
      date: Date.today,
      customer_id: @customer.id,
      store_id: @args[:store_id],
      product_id: @product.id,
      unit_price: @args[:amount_total],
      description: "Paid for #{@product.name}."
    }
    status, @invoice = Invoices::CreateInvoice.call(invoice_attributes: invoice_attributes)
    raise "Failed to create invoice" unless status == :success
  end
end
