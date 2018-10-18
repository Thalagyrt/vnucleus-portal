class AddNodeGroupToSolusPlanAndSolusNode < ActiveRecord::Migration
  def change
    add_column :solus_plans, :node_group, :string
    add_column :solus_nodes, :node_group, :string

    add_index :solus_nodes, :node_group

    execute "UPDATE solus_plans SET node_group='HDD'"
    execute "UPDATE solus_nodes SET node_group='HDD'"
  end
end
