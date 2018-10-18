class AddAffiliateEnabledToAccountsAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :affiliate_enabled, :boolean, default: false
  end
end

