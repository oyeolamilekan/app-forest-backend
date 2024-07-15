class WebhooksController < ApplicationController

  def stripe
    status, stripe_obj = Integrations::FetchIntegration.call(store_slug: store_slug, provider_id: "stripe")
    endpoint_secret = stripe_obj.endpoint_secret
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end
    case event.type
    when 'checkout.session.completed'
      github_username = event.data.object.custom_fields.find { |obj| obj.key = 'githubusername' }.text.value
      product_id = event.data.object.metadata.product_id
      ProcessFundJob.perform_later(github_username: github_username, product_id: product_id, store_slug: store_slug)
    end
    api_response(status: true, message: "Stripe checkout has worked", data: nil, status_code: :created)
  end

  private
  def store_slug
    params.require(:store_slug)
  end
end
