class AddStripeExpirationDateToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_expiration_date, :date
    add_index :accounts, :stripe_expiration_date
  end
end
