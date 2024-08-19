module Invoices
  class FetchInvoices < ApplicationService
    attr_reader :store_id, :customer_id, :page, :per_page

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 20

    def initialize(store_id: nil, customer_id: nil, page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
      @store_id = store_id
      @customer_id = customer_id
      @page = page.to_i
      @per_page = per_page.to_i
    end

    def call
      return [:error, "Either store_id or customer_id must be provided"] if store_id.nil? && customer_id.nil?
      return [:error, "Only one of store_id or customer_id should be provided"] if store_id.present? && customer_id.present?

      invoices = fetch_invoices
      [:success, invoices]
    end

    private

    def fetch_invoices
      base_query = Invoice.order(created_at: :desc)

      invoices = store_id ? base_query.where(store_id: store_id) : base_query.where(customer_id: customer_id)
      invoices
    end
  end
end