class AddCouponIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :coupon_id, :integer
    add_index :solus_servers, :coupon_id
  end
end
