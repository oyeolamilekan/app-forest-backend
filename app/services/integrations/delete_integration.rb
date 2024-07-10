module Integrations
  class DeleteIntegration < ApplicationService
    attr_reader :integration_public_id, :current_user

    def initialize(integration_public_id:, current_user:)
      @integration_public_id = integration_public_id
      @current_user = current_user
    end

    def call
      integration = Integration.find_by!(public_id: integration_public_id)
      return [:error, "Cannot delete integration that you don't own"] unless integration.store.user == current_user
      return [:success, "Integration has been successfully deleted."] if integration.destroy
      [:error, integration.errors.full_messages.first]
    rescue ActiveRecord::RecordNotFound
      [:error, "Integration not found"]
    end
  end
end
