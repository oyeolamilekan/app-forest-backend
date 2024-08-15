class WebhooksController < ApplicationController
  before_action :set_stripe_integration, only: [:stripe]

  def stripe
    event = verify_stripe_webhook
    return api_error(message: "Invalid payload or signature", status_code: :bad_request) unless event

    if event.type == 'checkout.session.completed'
      process_checkout_session(event.data.object)
    end

    api_response(status: true, message: "Stripe webhook processed successfully", data: nil, status_code: :ok)
  end

  private

  def set_stripe_integration
    status, @stripe_integration = Integrations::FetchIntegration.call(
      store_slug: store_slug, 
      provider_id: Integration::STRIPE
    )
    api_response(status: false, message: "Stripe integration not found", status_code: :not_found) unless status == :success
  end

  def verify_stripe_webhook
    Stripe::Webhook.construct_event(
      request.body.read,
      request.env['HTTP_STRIPE_SIGNATURE'],
      @stripe_integration.endpoint_secret
    )
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    nil
  end

  def process_checkout_session(session)
    customer_details = session.customer_details
    amount_total = session.amount_total
    github_username = extract_github_username(session)

    ProcessFundJob.perform_later(
      payment_id: session.id,
      name: customer_details.name,
      email: customer_details.email,
      github_username: github_username,
      product_id: session.metadata.product_id,
      store_id: @stripe_integration.store_id,
      amount_total: amount_total,
      store_slug: store_slug
    )
  end

  def extract_github_username(session)
    session.custom_fields.find { |field| field.key == 'githubusername' }&.text&.value
  end

  def store_slug
    params.require(:store_slug)
  end
end
