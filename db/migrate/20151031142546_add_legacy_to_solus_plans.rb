class AddLegacyToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :legacy, :boolean, default: false
  end
end
