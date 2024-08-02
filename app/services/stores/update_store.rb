module Stores
  class UpdateStore < ApplicationService
    attr_reader :public_id, :store_params, :user

    def initialize(user:, public_id:, store_params:)
      @public_id = public_id
      @store_params = store_params
      @user = user
    end

    def call
      store = Store.find_by(public_id: public_id)
      return [:error, "Store not found"] if store.nil?
      return [:error, "User does not have access"] if user != store.user
      return [:error, store.errors.objects.first.full_message] unless store.update(store_params)
      [:success, store]
    end
  end
end
