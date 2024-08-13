class ProductsController < ApplicationController
  before_action :authorize_request, except: [
    :fetch_products,
    :fetch_product,
    :create_payment_link
  ]

  def create_product
    image_urls = extract_image_urls(files)
    status, upload_file = AppFiles::Upload.call(file: file)
    status, result = Stores::FetchStore.call(store_attributes: { slug: store_slug }) if store_slug.present?
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
    api_response(status: true, message: "Products successfully retrieved", data: result, meta: result.pagination_meta)
  end

  def fetch_product
    status, result = Products::FetchProduct.call(product_attribute: { slug: product_slug }) if product_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :not_found) if status == :error
    api_response(status: true, message: "Products successfully retrieved", data: result)
  end

  def fetch_product_by_public_id
    status, result = Products::FetchProduct.call(product_attribute: { public_id: public_id }) if public_id.present?
    return api_response(status: false, message: result, data: nil, status_code: :not_found) if status == :error
    data = result.as_json.merge(repo_link: result.repo_link)
    api_response(status: true, message: "Products successfully retrieved", data: data)
  end

  def create_payment_link
    status_product, result_product = Products::FetchProduct.call(product_attribute: { slug: product_slug }) if product_slug.present?
    return api_error(message: result_integration, status_code: :not_found) if status_product == :error
    status_integration, result_integration = Integrations::FetchIntegration.call(store_slug: result_product.store.slug, provider_id: 'stripe')
    return api_error(message: result_integration, status_code: :not_found) if status_integration == :error
    status_payment_link, result_payment_link = Utils::CreatePaymentLink.call(
      price_cents: (result_product.price * 100).to_i, 
      api_key: result_integration.key, 
      product_name: result_product.name, 
      product_id: result_product.public_id,
      store_slug: result_product.store.slug
    )
    return api_response(status: false, message: result_payment_link, data: nil, status_code: :internal_server_error) if status_payment_link == :error
    api_response(status: true, message: "Payment link successfully created", data: { link: result_payment_link }, status_code: :created)
  end

  def update_product
    status, result = Stores::FetchStore.call(store_attributes: { slug: store_slug }) if store_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity) if status == :error
    return api_response(status: false, message: "You can't update product for a store your don't own", data: nil, status_code: :unprocessable_entity) unless result.user == current_user
    product_param = product_params.merge(store_id: result.id)
    status, result = Products::UpdateProduct.call(public_id: public_id, product_params: product_params, user: current_user)
    return api_response(status: true, message: "Successfully update product", data: result, status_code: :created) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity)
  end

  def delete_product
    status, result = Products::DeleteProduct.call(product_attribute: { slug: product_slug }, user: current_user)
    return api_error(message: "Products cannot be deleted", status_code: :internal_server_error) if status == :error
    api_response(status: true, message: "Products successfully deleted", data: nil, status_code: :no_content)
  end

  def delete_image
    status, result = Products::FetchProduct.call(product_attribute: { public_id: public_id }) if public_id.present?
    if result.gallery_imaages.delete(image_url)
      result.save ? api_response(status: true, message: "Image successfully deleted", data: nil, status_code: :no_content) : api_error(message: "Cannot delete image", status_code: :not_found)
    end
  end

  def add_image
    image_urls = extract_image_urls(files)
    status, result = Products::FetchProduct.call(product_attribute: { public_id: public_id }) if public_id.present?
    result.gallery_imaages.push(*image_urls)
    result.save ? api_response(status: true, message: "Image successfully added", data: nil, status_code: :no_content) : api_error(message: "Cannot add image", status_code: :not_found)
  end

  def change_product_logo
    status, result = Products::FetchProduct.call(product_attribute: { public_id: public_id }) if public_id.present?
    status, upload_file = AppFiles::Upload.call(file: file)
    result.update(image_url: upload_file["secure_url"]) ? api_response(status: true, message: "Image successfully change", data: nil, status_code: :no_content) : api_error(message: "Cannot add image", status_code: :not_found)
  end

  def change_store_logo
    status, result = Stores::FetchStore.call(store_attributes: { public_id: public_id }) if public_id.present?
    status, upload_file = AppFiles::Upload.call(file: file)
    result.update(logo_url: upload_file["secure_url"]) ? api_response(status: true, message: "Image successfully change", data: result, status_code: :ok) : api_error(message: "Cannot add image", status_code: :not_found)
  end

  private
  def files
    params.require(:files)
  end

  def file
    params.require(:file)
  end

  def product_params
    params.permit(:name, :description, :repo_link, :price)
  end

  def image_url
    params.require(:image_url)
  end

  def public_id
    params.require(:public_id)
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
