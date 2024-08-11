class AddPublicIdToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :public_id, :string
  end
end
