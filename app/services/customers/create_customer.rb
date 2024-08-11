module Customers
  class CreateCustomer < ApplicationService
    attr_reader :customer_attributes

    def initialize(customer_attributes:)
      @customer_attributes = customer_attributes
    end

    def call
      customer = Customer.create(customer_attributes)
      return [:error, customer.errors.objects.first.full_message] unless customer.persisted?
      return [:success, customer]
    end
  end
end
