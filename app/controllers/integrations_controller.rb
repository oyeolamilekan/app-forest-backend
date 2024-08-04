class IntegrationsController < ApplicationController
  before_action :authorize_request

  def fetch_integration_count
    status, result = Integrations::FetchIntegrations.call(store_slug: store_slug, current_user: current_user) if store_slug.present?
    api_response(status: true, message: "Fetch integration count", data: { count: result.count }, status_code: :ok)
  end

  def create_integration
    status, result = Stores::FetchStore.call(store_attributes: { slug: store_slug }) if store_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity) if status == :error
    return api_response(status: false, message: "You can't create integration for a store your don't own", data: nil, status_code: :unprocessable_entity) unless result.user == current_user
    integration_param = integration_params.merge(store_id: result.id)
    status, result = Integrations::CreateIntegration.call(integration_attributes: integration_param)
    return api_response(status: true, message: "Successfully created integration", data: result, status_code: :created) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity)
  end

  def update_integration
    status, result = Stores::FetchStore.call(store_attributes: { slug: store_slug }) if store_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity) if status == :error
    return api_response(status: false, message: "You can't update integration for a store your don't own", data: nil, status_code: :unprocessable_entity) unless result.user == current_user
    integration_param = integration_params.merge(store_id: result.id)
    status, result = Integrations::UpdateIntegration.call(integration_public_id: integration_public_id, integration_params: integration_params, user: current_user)
    return api_response(status: true, message: "Successfully update integration", data: result, status_code: :created) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :forbidden)
  end

  def delete_integration
    status, result = Stores::FetchStore.call(store_attributes: { slug: store_slug }) if store_slug.present?
    return api_response(status: false, message: result, data: nil, status_code: :unprocessable_entity) if status == :error
    return api_response(status: false, message: "You can't create integration for a store your don't own", data: nil, status_code: :unprocessable_entity) unless result.user == current_user
    status, result = Integrations::DeleteIntegration.call(integration_public_id: integration_public_id, current_user: current_user)
    return api_response(status: true, message: "Integrations successfully deleted", data: nil) if status == :success
    api_response(status: false, message: result, data: nil, status_code: :forbidden)
  end

  def fetch_integrations
    status, result = Integrations::FetchIntegrations.call(store_slug: store_slug, current_user: current_user)
    api_response(status: true, message: "Successfully fetched integrations", data: result, status_code: :ok)
  end

  private
  def store_slug
    params.require(:store_slug)
  end

  def integration_params
    params.permit(:provider, :key, :endpoint_secret)
  end

  def integration_public_id
    params.require(:integration_public_id)
  end
end
