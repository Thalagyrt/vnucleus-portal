class AddDefaultToUsedBackupSpace < ActiveRecord::Migration
  def change
    change_column_default :accounts_accounts, :used_backup_disk, 0
    execute "UPDATE accounts_accounts SET used_backup_disk=0 WHERE used_backup_disk IS NULL"
  end
end
