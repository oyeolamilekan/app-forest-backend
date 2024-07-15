module Stores
  class FetchStore < ApplicationService
    attr_reader :slug

    def initialize(slug:)
      @slug = slug
    end

    def call
      store = Rails.cache.fetch("store/#{slug}", expires_in: 12.hours) do
        Store.find_by(slug: slug)
      end
      return [:success, store] if store.present?
      return [:error, "Cannot find store."]
    end
  end
end
