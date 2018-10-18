class MoveLicensesToOwnModule < ActiveRecord::Migration
  def change
    rename_table :accounts_licenses, :licenses_licenses
  end
end
