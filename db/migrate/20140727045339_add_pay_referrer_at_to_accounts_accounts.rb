class AddPayReferrerAtToAccountsAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :pay_referrer_at, :date
    add_index :accounts_accounts, :pay_referrer_at
  end
end
