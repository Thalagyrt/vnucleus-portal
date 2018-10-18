class AddProductCodeAndDescriptionToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses_licenses, :product_code, :string
    add_column :licenses_licenses, :description, :string

    Licenses::License.find_each do |license|
      license.product_code = license.product.product_code
      license.description = license.product.description
      license.save!
    end
  end
end
