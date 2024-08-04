module Stores
  class FetchStore < ApplicationService
    attr_reader :store_attributes

    def initialize(store_attributes:)
      @store_attributes = store_attributes
    end

    def call
      store = Rails.cache.fetch("store/#{store_attributes.keys.first}/#{store_attributes.values.first}", expires_in: 5.minutes) do
        Store.find_by(store_attributes)
      end
      return [:success, store] if store.present?
      return [:error, "Cannot find store."]
    end
  end
end
