class AddAffiliateIdToAccountsAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :referrer_id, :integer
  end
end
