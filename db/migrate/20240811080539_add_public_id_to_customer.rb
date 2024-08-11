class AddPublicIdToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :public_id, :string
  end
end
