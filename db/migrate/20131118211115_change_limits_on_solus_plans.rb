class ChangeLimitsOnSolusPlans < ActiveRecord::Migration
  def up
    change_column :solus_plans, :ram, :bigint, limit: 8
    change_column :solus_plans, :disk, :bigint, limit: 8
    change_column :solus_plans, :transfer, :bigint, limit: 8
  end

  def down
    change_column :solus_plans, :ram, :integer, limit: 4
    change_column :solus_plans, :disk, :integer, limit: 4
    change_column :solus_plans, :transfer, :integer, limit: 4
  end
end

