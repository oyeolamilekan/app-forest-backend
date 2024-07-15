class AddLogoUrlToStore < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :logo_url, :string
  end
end
