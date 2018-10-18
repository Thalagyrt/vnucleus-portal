class AddCloseOnToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :close_on, :date
    add_index :accounts_accounts, :close_on
  end
end
