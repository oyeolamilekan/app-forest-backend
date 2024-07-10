module Integrations
  class UpdateIntegration < ApplicationService
    attr_reader :integration_public_id, :integration_params, :user

    def initialize(integration_public_id:, integration_params:, user:)
      @integration_public_id = integration_public_id
      @integration_params = integration_params
      @user = user
    end

    def call
      integration = Integration.find_by!(public_id: integration_public_id)
      return [:error, "Cannot edit integration that you don't own"] unless integration.store.user == user
      return [:success, "Integration has been successfully updated."] if integration.update(integration_params)
      [:error, integration.errors.full_messages.first]
    rescue ActiveRecord::RecordNotFound
      [:error, "Integration not found"]
    end
  end
end
