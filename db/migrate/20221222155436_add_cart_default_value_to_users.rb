class AddCartDefaultValueToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :cart, :binary, default: '{}'
  end
end
