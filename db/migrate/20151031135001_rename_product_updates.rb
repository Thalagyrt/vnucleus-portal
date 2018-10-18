class RenameProductUpdates < ActiveRecord::Migration
  def change
    rename_column :users_users, :receive_product_updates, :receive_product_announcements
  end
end
