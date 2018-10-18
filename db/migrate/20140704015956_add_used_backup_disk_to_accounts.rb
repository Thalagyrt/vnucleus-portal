class AddUsedBackupDiskToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :used_backup_disk, :bigint
    add_column :accounts_accounts, :backup_usage_rss_url, :string
  end
end
