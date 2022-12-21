class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name, limit: 30
    end
    add_index :categories, :name, unique: true
  end
end
