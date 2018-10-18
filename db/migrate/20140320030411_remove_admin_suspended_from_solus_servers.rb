class RemoveAdminSuspendedFromSolusServers < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :admin_suspended
  end
end
