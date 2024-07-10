module Products
  class CreateProduct < ApplicationService
    attr_reader :products_attributes

    def initialize(products_attributes:)
      @products_attributes = products_attributes
    end

    def call
      product = Product.create!(products_attributes)
      return [:error, product.errors.objects.first.full_message] unless product.persisted?
      return [:success, product]
    end
  end
end
