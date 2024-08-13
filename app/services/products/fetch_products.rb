module Products
  class FetchProducts < ApplicationService
    attr_reader :store_slug, :page, :per_page

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 20

    def initialize(store_slug:, page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
      @store_slug = store_slug
      @page = page.to_i
      @per_page = per_page.to_i
    end

    def call
      products = fetch_products
      [:success, products]
    rescue ActiveRecord::RecordNotFound => e
      [:error, "Store not found: #{e.message}"]
    rescue StandardError => e
      [:error, "An error occurred: #{e.message}"]
    end

    private

    def fetch_products
      Store.find_by!(slug: store_slug)
           .product
           .order(created_at: :desc)
           .page(page)
           .per(per_page)
    end
  end
end