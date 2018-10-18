class AddBeginsAtToOrdersCoupons < ActiveRecord::Migration
  def change
    add_column :orders_coupons, :begins_at, :datetime
    add_index :orders_coupons, :begins_at
  end
end
