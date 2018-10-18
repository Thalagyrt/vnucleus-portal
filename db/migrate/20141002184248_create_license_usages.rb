class CreateLicenseUsages < ActiveRecord::Migration
  def change
    create_table :licenses_usages do |t|
      t.integer :product_id
      t.integer :count
      t.datetime :created_at
    end

    add_index :licenses_usages, :product_id
    add_index :licenses_usages, :created_at
  end
end
