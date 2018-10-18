class AddMetadataToSolusClusters < ActiveRecord::Migration
  def change
    add_column :solus_clusters, :facility, :string
    add_column :solus_clusters, :transit_providers, :string
  end
end
