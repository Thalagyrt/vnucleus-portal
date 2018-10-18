class RemoveStripeCustomerFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :stripe_customer
  end

  def down
    add_column :users, :stripe_customer, :string
  end
end
