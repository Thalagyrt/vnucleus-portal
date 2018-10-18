class AddSynchronizedAtToSolusClusters < ActiveRecord::Migration
  def change
    add_column :solus_clusters, :synchronized_at, :datetime
  end
end
