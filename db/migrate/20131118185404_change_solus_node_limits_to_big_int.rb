class ChangeSolusNodeLimitsToBigInt < ActiveRecord::Migration
  def up
    change_column :solus_nodes, :available_ram, :bigint, limit: 8
    change_column :solus_nodes, :available_disk, :bigint, limit: 8
  end

  def down
    change_column :solus_nodes, :available_ram, :integer, limit: 4
    change_column :solus_nodes, :available_disk, :integer, limit: 4
  end
end
