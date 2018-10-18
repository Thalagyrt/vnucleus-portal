class AddLockedToSolusNodes < ActiveRecord::Migration
  def change
    add_column :solus_nodes, :locked, :boolean, default: false
  end
end
