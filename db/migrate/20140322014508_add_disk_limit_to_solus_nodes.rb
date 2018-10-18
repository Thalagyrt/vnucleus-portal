class AddDiskLimitToSolusNodes < ActiveRecord::Migration
  def change
    add_column :solus_nodes, :disk_limit, :bigint
  end
end
