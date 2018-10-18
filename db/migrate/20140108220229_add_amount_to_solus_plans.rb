class AddAmountToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :amount, :integer
  end
end
