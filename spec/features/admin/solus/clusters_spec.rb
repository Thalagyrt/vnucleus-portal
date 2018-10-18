require 'spec_helper'

feature "admin/solus/clusters" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views solus clusters" do
    given!(:clusters) { 3.times.map { create :solus_cluster } }

    scenario do
      visit admin_solus_clusters_path

      clusters.each do |cluster|
        expect(page).to have_content(cluster.name)
      end
    end
  end

  feature "admin views solus cluster" do
    given!(:cluster) { create :solus_cluster }
    given!(:nodes) { 3.times.map { create :solus_node, cluster: cluster } }

    scenario do
      visit admin_solus_cluster_path(cluster)

      expect(page).to have_content(cluster.name)

      nodes.each do |node|
        expect(page).to have_content(node.name)
      end
    end
  end
end