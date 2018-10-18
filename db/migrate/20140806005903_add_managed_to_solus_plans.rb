class AddManagedToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :managed, :boolean, default: true
  end
end
