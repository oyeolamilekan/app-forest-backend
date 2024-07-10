module Stores
  class FetchStores < ApplicationService
    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def call
      stores = Store.where(user: user)
      return [:success, stores]
    end
  end
end
