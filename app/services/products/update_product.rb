module Products
  class UpdateProduct < ApplicationService
    attr_reader :product_slug, :product_params, :user

    def initialize(product_slug:, product_params:, user:)
      @product_slug = product_slug
      @product_params = product_params
      @user = user
    end

    def call
      product = Product.find_by(slug: product_slug)
      return [:error, "product not found"] if product.nil?
      return [:error, "Cannot edit integration that you don't own"] unless product.store.user == user
      return [:error, product.errors] unless product.update(product_params)
      [:success, product]
    end
  end
end
