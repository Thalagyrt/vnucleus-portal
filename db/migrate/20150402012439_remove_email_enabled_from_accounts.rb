class RemoveEmailEnabledFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts_accounts, :email_enabled
  end
end
