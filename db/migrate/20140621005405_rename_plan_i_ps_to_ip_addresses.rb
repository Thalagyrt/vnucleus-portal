class RenamePlanIPsToIpAddresses < ActiveRecord::Migration
  def change
    rename_column :solus_plans, :ips, :ip_addresses
  end
end
