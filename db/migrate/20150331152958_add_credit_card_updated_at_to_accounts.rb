class AddCreditCardUpdatedAtToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :credit_card_updated_at, :datetime
    add_index :accounts_accounts, :credit_card_updated_at
    execute 'UPDATE accounts_accounts SET credit_card_updated_at=created_at'
  end
end
