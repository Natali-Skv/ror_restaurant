class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :users, null: false, foreign_key: true
      t.binary :cart, null: false
      t.string :comment, limit: 256
      t.string :address, limit: 256

      t.timestamps
    end
  end
end
