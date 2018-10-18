class AddNetworkOutToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :network_out, :integer
  end
end
