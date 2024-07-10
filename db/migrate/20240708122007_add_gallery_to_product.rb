class AddGalleryToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :gallery_imaages, :text, array: true, default: []
  end
end
