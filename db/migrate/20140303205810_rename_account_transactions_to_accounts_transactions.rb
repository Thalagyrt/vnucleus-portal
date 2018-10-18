class RenameAccountTransactionsToAccountsTransactions < ActiveRecord::Migration
  def up
    rename_table :account_transactions, :accounts_transactions
  end

  def down
    rename_table :accounts_transactions, :account_transactions
  end
end
