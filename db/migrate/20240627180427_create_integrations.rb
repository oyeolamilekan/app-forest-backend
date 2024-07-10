class CreateIntegrations < ActiveRecord::Migration[7.0]
  def change
    create_table :integrations do |t|
      t.string :provider
      t.string :key
      t.string :public_id
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
