class AddFeatureStatusToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :feature_status, :integer
    add_index :solus_plans, :feature_status
  end
end
