module Products
  class FetchProducts < ApplicationService
    attr_reader :store_slug, :page, :per

    def initialize(store_slug:, page: nil, per: nil)
      @store_slug = store_slug
      @page = page
      @per = per
    end

    def call
      products = Product.joins(:store).where(stores: { slug: store_slug }).page(page || 1).per(per || 20) 
      return [:success, products]
    end
  end
end
