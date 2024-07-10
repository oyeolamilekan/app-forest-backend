module Integrations
  class CreateIntegration < ApplicationService
    attr_reader :integration_attributes

    def initialize(integration_attributes:)
      @integration_attributes = integration_attributes
    end

    def call
      integration = Integration.create(integration_attributes)
      return [:error, integration.errors.objects.first.full_message] unless integration.persisted?
      return [:success, integration]
    end
  end
end
