module Integrations
  class FetchIntegration < ApplicationService
    attr_reader :store_slug, :provider_id

    def initialize(store_slug:, provider_id:)
      @store_slug = store_slug
      @provider_id = provider_id
    end

    def call
      store = Store.find_by(slug: store_slug)
      return [:error, "Store not found"] unless store

      integration = store.integration.find_by(provider: provider_id)
      return [:error, "Integration not found"] unless integration
      [:success, integration]
    rescue => e
      [:error, "An unexpected error occurred: #{e.message}"]
    end
  end
end
