class CachePolymorphicDataOnChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :server_hostname, :string
    add_column :monitoring_checks, :server_long_id, :string
  end
end
