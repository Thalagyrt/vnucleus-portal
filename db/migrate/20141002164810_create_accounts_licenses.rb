class CreateAccountsLicenses < ActiveRecord::Migration
  def change
    create_table :accounts_licenses do |t|
      t.integer :account_id

      t.integer :amount
      t.integer :count
      t.string  :description
      t.string  :product_code

      t.date    :next_due
    end

    add_index :accounts_licenses, :account_id
    add_index :accounts_licenses, :next_due
  end
end
