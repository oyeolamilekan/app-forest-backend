class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.references :store, null: false, foreign_key: true
      t.string :slug
      t.string :url
      t.string :public_id

      t.timestamps
    end
  end
end
