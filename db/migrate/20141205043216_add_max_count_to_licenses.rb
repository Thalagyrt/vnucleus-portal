class AddMaxCountToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses_licenses, :max_count, :integer

    execute 'UPDATE licenses_licenses SET max_count = count'
  end
end
