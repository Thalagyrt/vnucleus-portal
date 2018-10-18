class RenameLoginUrlToHostname < ActiveRecord::Migration
  def change
    rename_column :accounts_backup_users, :login_url, :hostname
  end
end
