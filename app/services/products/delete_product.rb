module Products
  class DeleteProduct < ApplicationService
    attr_reader :product_attribute, :user

    def initialize(product_attribute:, user:)
      @product_attribute = product_attribute
      @user = user
    end

    def call
      product = Product.find_by(product_attribute)
      return [:error, :product_not_found] unless product

      return [:error, :unauthorized] unless user_owns_product?(product)

      return [:error, product.errors.full_messages] unless product.destroy

      [:success, product]
    end

    private

    def user_owns_product?(product)
      product.store.user == user
    end
  end
end
