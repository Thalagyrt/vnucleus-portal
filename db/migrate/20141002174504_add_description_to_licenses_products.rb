class AddDescriptionToLicensesProducts < ActiveRecord::Migration
  def change
    add_column :licenses_products, :description, :string
  end
end
