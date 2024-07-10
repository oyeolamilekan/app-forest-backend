class AddEndpointSecretToIntegrations < ActiveRecord::Migration[7.0]
  def change
    add_column :integrations, :endpoint_secret, :string
  end
end
