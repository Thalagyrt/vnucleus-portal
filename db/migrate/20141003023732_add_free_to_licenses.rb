class AddFreeToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses_licenses, :free, :boolean, default: false
  end
end
