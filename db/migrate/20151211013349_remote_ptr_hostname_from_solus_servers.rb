class RemotePtrHostnameFromSolusServers < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :ptr_hostname
  end
end
