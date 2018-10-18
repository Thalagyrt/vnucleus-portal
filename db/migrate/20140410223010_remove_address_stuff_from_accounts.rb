class RemoveAddressStuffFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts_accounts, :address_line1
    remove_column :accounts_accounts, :address_line2
    remove_column :accounts_accounts, :address_city
    remove_column :accounts_accounts, :address_state
    remove_column :accounts_accounts, :address_zip
    remove_column :accounts_accounts, :address_country
  end
end
