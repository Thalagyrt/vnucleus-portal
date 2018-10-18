class SetDefaultLimitsOnSolusClusters < ActiveRecord::Migration
  def change
    change_column_default :solus_nodes, :ram_limit, 1
    change_column_default :solus_nodes, :disk_limit, 1
  end
end
