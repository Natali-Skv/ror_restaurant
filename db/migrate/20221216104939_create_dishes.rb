class CreateDishes < ActiveRecord::Migration[6.1]
  def change
    create_table :dishes do |t|
      t.string :name, limit: 80
      t.text :description
      t.string :image_path
      t.integer :calories
      t.integer :weight
      t.integer :price
      t.references :categories, null: false, foreign_key: true
    end
  end
end
