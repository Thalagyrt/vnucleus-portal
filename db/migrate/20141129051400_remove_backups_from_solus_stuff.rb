class RemoveBackupsFromSolusStuff < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :backup_disk
    remove_column :solus_plans, :backup_disk
  end
end
