module Products
  class FetchProduct < ApplicationService
    attr_reader :product_attribute

    def initialize(product_attribute:)
      @product_attribute = product_attribute
    end

    def call
      product = Rails.cache.fetch("product/#{product_attribute.keys.first}/#{product_attribute.values.first}") do
        Product.find_by(product_attribute)
      end
      return [:error, "Product not found"] unless product
      return [:error, product.errors.full_messages] unless product.persisted?

      [:success, product]
    end
  end
end
