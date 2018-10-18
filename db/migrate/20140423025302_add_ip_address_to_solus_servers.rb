class AddIpAddressToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :ip_address, :string
    add_index :solus_servers, :ip_address
  end
end
