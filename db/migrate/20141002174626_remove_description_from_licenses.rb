class RemoveDescriptionFromLicenses < ActiveRecord::Migration
  def change
    remove_column :licenses_licenses, :description
  end
end
