class AddAddressToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :address_line1, :string
    add_column :accounts_accounts, :address_line2, :string
    add_column :accounts_accounts, :address_city, :string
    add_column :accounts_accounts, :address_state, :string
    add_column :accounts_accounts, :address_zip, :string
    add_column :accounts_accounts, :address_country, :string
  end
end
