class AddReferenceToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :product, null: false, foreign_key: true
  end
end
