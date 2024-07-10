module Stores
  class CreateStore < ApplicationService
    attr_reader :store_attributes

    def initialize(store_attributes:)
      @store_attributes = store_attributes
    end

    def call
      store = Store.create(store_attributes)
      return [:error, store.errors.objects.first.full_message] unless store.persisted?
      return [:success, store]
    end
  end
end
