class AddRepoLinkToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :repo_link, :string
  end
end
