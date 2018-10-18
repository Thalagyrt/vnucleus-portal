class CleanUpAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :stripe_customer_id
    remove_column :accounts, :state
  end
end
