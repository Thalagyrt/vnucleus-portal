class AddReceiveProductUpdatesToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :receive_product_updates, :boolean, default: false
    add_index :users_users, :receive_product_updates
  end
end
