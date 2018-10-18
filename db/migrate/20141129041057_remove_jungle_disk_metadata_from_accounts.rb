class RemoveJungleDiskMetadataFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts_accounts, :backup_atom_url
    remove_column :accounts_accounts, :backup_usage_rss_url
  end
end
