class AddEmailEnabledToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :email_enabled, :boolean, default: false
  end
end
