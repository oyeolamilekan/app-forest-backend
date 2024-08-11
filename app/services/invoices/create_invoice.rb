module Invoices
  class CreateInvoice < ApplicationService
    attr_reader :invoice_attributes

    def initialize(invoice_attributes:)
      @invoice_attributes = invoice_attributes
    end

    def call
      invoice = Invoice.create(invoice_attributes)
      return [:error, invoice.errors.objects.first.full_message] unless invoice.persisted?
      return [:success, invoice]
    end
  end
end