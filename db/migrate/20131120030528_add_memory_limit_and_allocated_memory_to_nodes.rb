class AddMemoryLimitAndAllocatedMemoryToNodes < ActiveRecord::Migration
  def change
    add_column :solus_nodes, :ram_limit, :bigint, length: 8
    add_column :solus_nodes, :allocated_ram, :bigint, length: 8
  end
end
