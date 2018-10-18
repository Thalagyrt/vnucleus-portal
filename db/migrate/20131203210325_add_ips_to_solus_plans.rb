class AddIpsToSolusPlans < ActiveRecord::Migration
  def up
    add_column :solus_plans, :ips, :integer
    execute 'UPDATE solus_plans SET ips=1'
  end

  def down
    remove_column :solus_plans, :ips
  end
end
