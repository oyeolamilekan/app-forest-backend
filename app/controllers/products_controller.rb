class ProductsController < ApplicationController
  before_action :authorize_request, except: [
    :fetch_products,
    :fetch_product
  ]

  def create_product
    image_urls = extract_image_urls(params[:files])
    status, upload_file = AppFiles::Upload.call(file: params[:file])
    status, result = Stores::FetchStore.call(slug: store_slug) if store_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity) if status == :error
    return api_response(status: false, message: "You can't create product for a store your don't own", data: nil, status_code: :unprocessable_entity) unless result.user == current_user
    product_param = product_params.merge(store_id: result.id, image_url: upload_file["secure_url"], gallery_imaages: image_urls)
    status, result = Products::CreateProduct.call(products_attributes: product_param)
    return api_response(status: true, message: "Successfully created product", data: result, status_code: :created) if status == :success
    api_response(status: false, message: "result", data: nil, status_code: :unprocessable_entity)
  end

  def fetch_product_count
    status, result = Products::FetchProducts.call(store_slug: store_slug)
    api_response(status: true, message: "Products count retrieved", data: { count: result.count })
  end

  def fetch_products
    status, result = Products::FetchProducts.call(store_slug: store_slug, page: params[:page])
    api_response(status: true, message: "Products successfully retrieved", data: result.to_a, meta: result.pagination_meta)
  end

  def fetch_product
    status, result = Products::FetchProduct.call(product_attribute: { slug: product_slug }) if product_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :not_found) if status == :error
    api_response(status: true, message: "Products successfully retrieved", data: result)
  end

  def update_product
    status, result = Stores::FetchStore.call(slug: store_slug) if store_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity) if status == :error
    return api_response(status: false, message: "You can't update product for a store your don't own", data: nil, status_code: :unprocessable_entity) unless result.user == current_user
    product_param = product_params.merge(store_id: result.id)
    status, result = Products::UpdateProduct.call(product_slug: product_slug, product_params: product_params, user: current_user)
    return api_response(status: true, message: "Successfully update product", data: result, status_code: :created) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity)
  end

  private
  def product_params
    params.permit(:name, :description, :repo_link, :price)
  end

  def store_slug
    params.require(:store_slug)
  end

  def product_slug
    params.require(:product_slug)
  end

  def extract_image_urls(files)
    return [] unless files

    files.values.map do |file|
      _, upload_file = AppFiles::Upload.call(file: file)
      upload_file["secure_url"]
    end
  end
end
