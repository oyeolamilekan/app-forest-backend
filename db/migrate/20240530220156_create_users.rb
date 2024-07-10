class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.text :last_name
      t.text :email
      t.text :password
      t.text :password_digest
      t.text :public_id

      t.timestamps
    end
  end
end
