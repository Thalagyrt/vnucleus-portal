class AddAdminSuspendedToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :admin_suspended, :boolean
  end
end
