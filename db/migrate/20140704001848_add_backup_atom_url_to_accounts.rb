class AddBackupAtomUrlToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :backup_enabled, :boolean, default: false
    add_column :accounts_accounts, :backup_atom_url, :string

    add_column :accounts_accounts, :backup_username, :string
    add_column :accounts_accounts, :backup_password, :string

    add_index :accounts_accounts, :backup_enabled
  end
end
