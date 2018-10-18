class AddClusterIdToServers < ActiveRecord::Migration
  def change
    add_column :servers, :cluster_id, :integer
    add_index :servers, :cluster_id
  end
end
