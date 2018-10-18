class CreateLicensesProducts < ActiveRecord::Migration
  def change
    create_table :licenses_products do |t|
      t.string :product_code
    end
  end
end
