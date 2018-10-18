class AddProvisionTimesToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :provision_started_at, :datetime
    add_column :solus_servers, :provision_completed_at, :datetime
  end
end
