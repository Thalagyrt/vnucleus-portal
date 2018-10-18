class AddPtrHostnameToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :ptr_hostname, :string
  end
end
