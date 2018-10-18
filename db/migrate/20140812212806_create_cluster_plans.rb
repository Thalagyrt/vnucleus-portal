class CreateClusterPlans < ActiveRecord::Migration
  def change
    create_table :solus_cluster_plans do |t|
      t.integer :cluster_id
      t.integer :plan_id
    end

    add_index :solus_cluster_plans, [:cluster_id, :plan_id], unique: true
  end
end
