class AddIp6AddressesToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :ipv6_addresses, :integer
    execute 'UPDATE solus_plans SET ipv6_addresses=16'
  end
end
