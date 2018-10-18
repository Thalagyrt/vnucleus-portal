class ChangeLicensesToReferenceProduct < ActiveRecord::Migration
  def change
    remove_column :licenses_licenses, :product_code
    add_column :licenses_licenses, :product_id, :integer
    add_index :licenses_licenses, :product_id
  end
end
