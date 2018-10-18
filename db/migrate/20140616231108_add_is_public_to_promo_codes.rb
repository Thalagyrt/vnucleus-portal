class AddIsPublicToPromoCodes < ActiveRecord::Migration
  def change
    add_column :orders_coupons, :published, :boolean, default: false
    add_index :orders_coupons, :published
  end
end
