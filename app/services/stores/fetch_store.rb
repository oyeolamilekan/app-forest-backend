module Stores
  class FetchStore < ApplicationService
    attr_reader :slug

    def initialize(slug:)
      @slug = slug
    end

    def call
      store = Store.find_by(slug: slug)
      return [:success, store] if store.present?
      return [:error, "Cannot find store."]
    end
  end
end
