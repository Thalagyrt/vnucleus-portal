class AddStripeIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_id, :string
  end
end
