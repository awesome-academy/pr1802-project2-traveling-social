class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :image
      t.integer :lr_image_id
      t.string :lr_image_type

      t.timestamps
    end
    add_index :images, [:lr_image_id, :lr_image_type]
  end
end
