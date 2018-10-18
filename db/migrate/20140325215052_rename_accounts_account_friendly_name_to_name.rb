class RenameAccountsAccountFriendlyNameToName < ActiveRecord::Migration
  def change
    rename_column :accounts_accounts, :friendly_name, :name
  end
end
