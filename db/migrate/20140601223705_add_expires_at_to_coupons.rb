class AddExpiresAtToCoupons < ActiveRecord::Migration
  def change
    add_column :orders_coupons, :expires_at, :datetime
    add_index :orders_coupons, :expires_at
  end
end
