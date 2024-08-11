class AddStoreReferenceToCustomersAndInvoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :customers, :store, null: false, foreign_key: true
    add_reference :invoices, :store, null: false, foreign_key: true  
  end
end
