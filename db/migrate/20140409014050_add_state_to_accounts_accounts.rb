class AddStateToAccountsAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :state, :string
    execute "UPDATE accounts_accounts SET state='active'"
  end
end
