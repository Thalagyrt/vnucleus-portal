class RemoveAvailableIPsFromClusters < ActiveRecord::Migration
  def change
    remove_column :solus_clusters, :available_ipv4
    remove_column :solus_clusters, :available_ipv6
  end
end
