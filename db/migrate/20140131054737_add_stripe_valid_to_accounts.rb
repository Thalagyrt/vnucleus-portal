class AddStripeValidToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_valid, :boolean
  end
end
