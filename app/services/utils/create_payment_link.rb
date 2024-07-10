module Utils
  class CreatePaymentLink < ApplicationService
    attr_reader :price_cents, :api_key, :product_name, :product_id

    def initialize(price_cents:, api_key:, product_name:, product_id:)
      @price_cents = price_cents
      @api_key = api_key
      @product_name = product_name
      @product_id = product_id
    end

    def call
      Stripe.api_key = api_key

      begin
        session = Stripe::Checkout::Session.create({
          payment_method_types: ['card'],
          line_items: [{
            price_data: {
              currency: 'usd',
              product_data: { name: product_name },
              unit_amount: price_cents, # Amount in cents
            },
            quantity: 1, # Single item purchase
          }],
          mode: 'payment',
          success_url: 'https://website.com/' + 'success?session_id={CHECKOUT_SESSION_ID}',
          cancel_url: 'https://website.com/' + 'cancel',
          custom_fields: [
            {
              key: 'githubusername',
              label: { type: 'custom', custom: 'Github Username' },
              type: 'text',
            }
          ],
          metadata: {
            product_id: product_id
          }
        })
        [:success, session.url]
      rescue Stripe::StripeError => e
        [:error, "Stripe error: #{e.message}"]
      rescue => e
        [:error, "Error creating payment link: #{e.message}"]
      ensure
        Stripe.api_key = nil  # Reset the API key after use
      end
    end
  end
end
