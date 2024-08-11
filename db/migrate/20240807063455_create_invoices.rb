class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.references :customer, null: false, foreign_key: true
      t.date :date
      t.string :description
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :total

      t.timestamps
    end
  end
end
