class CreatePaymentApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_api_keys do |t|
      t.references :store, null: false, foreign_key: true
      t.string :platform
      t.string :auth_key
      t.string :webhook_key
      t.string :public_id

      t.timestamps
    end
  end
end
