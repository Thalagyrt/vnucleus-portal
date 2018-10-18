class AddSynchronizedAtToSolusNodes < ActiveRecord::Migration
  def change
    add_column :solus_nodes, :synchronized_at, :datetime
  end
end
