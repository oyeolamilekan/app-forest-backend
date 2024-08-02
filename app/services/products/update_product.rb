module Products
  class UpdateProduct < ApplicationService
    attr_reader :public_id, :product_params, :user

    def initialize(public_id:, product_params:, user:)
      @public_id = public_id
      @product_params = product_params
      @user = user
    end

    def call
      product = Product.find_by(public_id: public_id)
      return [:error, "product not found"] if product.nil?
      return [:error, "Cannot edit integration that you don't own"] unless product.store.user == user
      return [:error, product.errors] unless product.update(product_params)
      [:success, product]
    end
  end
end
