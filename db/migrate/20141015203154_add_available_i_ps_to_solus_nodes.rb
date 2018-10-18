class AddAvailableIPsToSolusNodes < ActiveRecord::Migration
  def change
    add_column :solus_nodes, :available_ipv4, :integer, default: 0
    add_column :solus_nodes, :available_ipv6, :integer, default: 0

    add_index :solus_nodes, :available_ipv4
    add_index :solus_nodes, :available_ipv6
  end
end
