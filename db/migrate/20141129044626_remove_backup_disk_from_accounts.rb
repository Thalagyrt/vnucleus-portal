class RemoveBackupDiskFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts_accounts, :used_backup_disk
    remove_column :accounts_accounts, :max_used_backup_disk
  end
end
