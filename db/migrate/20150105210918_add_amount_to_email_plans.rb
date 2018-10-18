class AddAmountToEmailPlans < ActiveRecord::Migration
  def change
    add_column :email_plans, :amount, :integer
  end
end
