class AddBypassFirewallToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :bypass_firewall, :boolean, default: false
  end
end
