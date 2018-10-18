class AddBackupUserIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :backup_user_id, :integer
    add_index :solus_servers, :backup_user_id
  end
end
