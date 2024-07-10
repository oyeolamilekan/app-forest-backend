module Stores
  class UpdateStore < ApplicationService
    attr_reader :store_slug, :store_params, :user

    def initialize(user:, store_slug:, store_params:)
      @store_slug = store_slug
      @store_params = store_params
      @user = user
    end

    def call
      store = Store.find_by(slug: store_slug)
      return [:error, "Store not found"] if store.nil?
      return [:error, "User does not have access"] if user != store.user
      return [:error, store.errors.objects.first.full_message] unless store.update(store_params)
      [:success, store]
    end
  end
end
