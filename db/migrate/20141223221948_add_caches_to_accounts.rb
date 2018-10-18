class AddCachesToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :balance_cache, :integer, default: 0
    add_column :accounts_accounts, :server_count_cache, :integer, default: 0
    add_column :accounts_accounts, :monthly_rate_cache, :integer, default: 0

    add_index :accounts_accounts, :balance_cache
    add_index :accounts_accounts, :server_count_cache
    add_index :accounts_accounts, :monthly_rate_cache

    Accounts::Account.find_each do |account|
      account.update_balance_cache!
      account.update_monthly_rate_cache!
      account.update_server_count_cache!
    end
  end
end
