class RemoveBackupsFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts_accounts, :backup_enabled
    remove_column :accounts_accounts, :backup_username
    remove_column :accounts_accounts, :backup_password
  end
end
