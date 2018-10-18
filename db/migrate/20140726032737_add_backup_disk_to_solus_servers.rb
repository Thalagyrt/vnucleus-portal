class AddBackupDiskToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :backup_disk, :bigint
    execute 'UPDATE solus_servers SET backup_disk=solus_plans.backup_disk FROM solus_plans WHERE solus_plans.id=solus_servers.plan_id'
  end
end
