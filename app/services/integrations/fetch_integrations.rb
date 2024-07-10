module Integrations
  class FetchIntegrations < ApplicationService
    attr_reader :store_slug, :current_user

    def initialize(store_slug:, current_user:)
      @store_slug = store_slug
      @current_user = current_user
    end

    def call
      store = Store.find_by(slug: store_slug)
      return [:error, "Store not found"] unless store
      return [:error, "Unauthorized access"] unless store.user == current_user

      integrations = store.integration
      [:success, integrations]
    rescue => e
      [:error, "An unexpected error occurred: #{e.message}"]
    end
  end
end
