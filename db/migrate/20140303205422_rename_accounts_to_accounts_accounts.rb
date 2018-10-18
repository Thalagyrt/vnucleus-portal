class RenameAccountsToAccountsAccounts < ActiveRecord::Migration
  def up
    rename_table :accounts, :accounts_accounts
  end

  def down
    rename_table :accounts_accounts, :accounts
  end
end
