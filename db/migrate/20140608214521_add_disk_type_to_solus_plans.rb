class AddDiskTypeToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :disk_type, :string
    execute "UPDATE solus_plans SET disk_type='SSD' WHERE node_group='SSD'"
    execute "UPDATE solus_plans SET disk_type='HDD' WHERE node_group='HDD'"
  end
end
