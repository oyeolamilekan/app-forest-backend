class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :logo
      t.references :user, null: false, foreign_key: true
      t.string :public_id

      t.timestamps
    end
  end
end
