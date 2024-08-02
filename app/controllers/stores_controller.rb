class StoresController < ApplicationController
  before_action :authorize_request, except: [
    :fetch_store
  ]

  def create_store
    status_file, upload_file = AppFiles::Upload.call(file: params[:file])
    store_param = store_params.merge(user: current_user, logo_url: upload_file["secure_url"])
    status, result = Stores::CreateStore.call(store_attributes: store_param)
    return api_response(status: true, message: "Successfully created store", data: result, status_code: :created) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity)
  end

  def fetch_store
    status, result = Stores::FetchStore.call(slug: store_slug)
    return api_response(status: true, message: "Stores successfully retrieved", data: result) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity)
  end
  
  def fetch_stores
    status, result = Stores::FetchStores.call(user: current_user)
    api_response(status: true, message: "Stores successfully retrieved", data: result)
  end

  def update_store
    status, result = Stores::UpdateStore.call(user: current_user, public_id: public_id, store_params: store_params)
    return api_response(status: true, message: "Successfully fetched store", data: result, status_code: :created) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity)
  end
 
  private
  def store_params
    params.permit(:name, :logo, :last_name, :description)
  end

  def store_slug
    params.require(:store_slug)
  end

  def public_id
    params.require(:public_id)
  end
end
