class MoveAmountToLicenseProduct < ActiveRecord::Migration
  def change
    add_column :licenses_products, :amount, :integer, default: 0
    remove_column :licenses_licenses, :amount
  end
end
