class RemoveManagedFromServers < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :managed
  end
end
