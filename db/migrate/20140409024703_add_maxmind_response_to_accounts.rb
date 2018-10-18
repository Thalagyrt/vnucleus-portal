class AddMaxmindResponseToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :maxmind_response, :text
  end
end
