class AddStatusToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :status, :integer
    add_index :solus_plans, :status
    execute 'UPDATE solus_plans SET status=1'
  end
end
