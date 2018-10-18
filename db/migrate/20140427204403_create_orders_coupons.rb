class CreateOrdersCoupons < ActiveRecord::Migration
  def change
    create_table :orders_coupons do |t|
      t.string :coupon_code
      t.decimal :factor
      t.integer :status
    end

    add_index :orders_coupons, :coupon_code, unique: true
    add_index :orders_coupons, :status
  end
end
