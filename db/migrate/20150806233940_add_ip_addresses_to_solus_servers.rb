class AddIpAddressesToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :ip_address_list, :text
  end
end
