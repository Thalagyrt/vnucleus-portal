class AddMaxUserBackupDiskToAccountsAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :max_used_backup_disk, :bigint, default: 0
  end
end
