class CreateAppFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :app_files do |t|
      t.string :title
      t.string :file_url
      t.string :file_type

      t.timestamps
    end
  end
end
