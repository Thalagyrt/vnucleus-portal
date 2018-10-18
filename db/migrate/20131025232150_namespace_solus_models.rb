class NamespaceSolusModels < ActiveRecord::Migration
  def change
    rename_table :clusters, :solus_clusters
    rename_table :nodes, :solus_nodes
    rename_table :plans, :solus_plans
    rename_table :servers, :solus_servers
    rename_table :templates, :solus_templates
  end
end
