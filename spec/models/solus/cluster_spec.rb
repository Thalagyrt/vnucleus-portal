require 'spec_helper'

describe Solus::Cluster do
  let(:cluster) { create :solus_cluster }

  describe "#get_node" do
    context "when the node already exists" do
      let!(:xen1) { cluster.nodes.create(available_ipv4: 16, available_ipv6: 256, name: "Xen1", allocated_ram: 700.megabytes, ram_limit: 1400.megabytes, available_disk: 40.gigabytes) }

      it "returns the node" do
        expect(cluster.get_node("Xen1")).to eq(xen1)
      end
    end

    context "when the node does not exist" do
      it "adds the node" do
        expect { cluster.get_node("Xen1") }.to change { cluster.nodes.count }.by(1)
      end
    end
  end

  describe "#prune_nodes" do
    let!(:xen2) { cluster.nodes.create(name: "Xen2", allocated_ram: 700.megabytes, ram_limit: 1400.megabytes, available_disk: 40.gigabytes) }

    it "removes nodes that aren't specified as valid" do
      expect { cluster.prune_nodes(["Xen1"]) }.to change { cluster.nodes.count }.by(-1)
    end
  end

  describe "#select_node" do
    let!(:xen1) { cluster.nodes.create(name: 'Xen1', available_ipv4: 16, available_ipv6: 256, allocated_ram: 700.megabytes, ram_limit: 1400.megabytes, available_disk: 40.gigabytes, node_group: 'HDD') }
    let!(:xen2) { cluster.nodes.create(name: 'Xen2', available_ipv4: 16, available_ipv6: 256, allocated_ram: 4.gigabytes, ram_limit: 8.gigabytes, available_disk: 300.gigabytes, node_group: 'HDD') }
    let!(:ssd1) { cluster.nodes.create(name: 'SSD1', available_ipv4: 16, available_ipv6: 256, allocated_ram: 2.gigabytes, ram_limit: 8.gigabytes, available_disk: 300.gigabytes, node_group: 'SSD') }

    let(:plan) { build :solus_plan, ram: 1.gigabyte, disk: 50.gigabytes, ip_addresses: 1, ipv6_addresses: 16, node_group: 'HDD' }

    it "selects a node with enough resources" do
      expect(cluster.select_node(plan)).to eq(xen2)
    end

    it "does not pick nodes without enough resources" do
      expect(cluster.select_node(plan)).to_not eq(xen1)
    end

    it "selects a node based on the nodegroup" do
      plan.node_group = 'SSD'

      expect(cluster.select_node(plan)).to eq(ssd1)
    end

    context "with positive template affinity" do
      let!(:xen3) { cluster.nodes.create(name: 'Xen3', available_ipv4: 16, available_ipv6: 256, allocated_ram: 4.gigabytes, ram_limit: 8.gigabytes, available_disk: 300.gigabytes, node_group: 'HDD') }

      let!(:template) { create :solus_template, affinity_group: "affine" }
      let!(:server) { create :solus_server, node: xen2, cluster: cluster, state: :active, plan: plan, template: template }

      it "selects the node that already has the template provisioned" do
        expect(cluster.select_node(plan, template)).to eq(xen2)
      end

      it "does not select the node that doesn't have the template provisioned" do
        expect(cluster.select_node(plan, template)).to_not eq(xen3)
      end
    end

    context "with negative template affinity" do
      let!(:xen3) { cluster.nodes.create(name: 'Xen3', available_ipv4: 16, available_ipv6: 256, allocated_ram: 4.gigabytes, ram_limit: 8.gigabytes, available_disk: 300.gigabytes, node_group: 'HDD') }

      let!(:template) { create :solus_template, affinity_group: "!affine" }

      let!(:affine_template) { create :solus_template, affinity_group: "affine" }
      let!(:server) { create :solus_server, node: xen2, cluster: cluster, state: :active, plan: plan, template: affine_template }

      it "selects the node that does not have the template provisioned" do
        expect(cluster.select_node(plan, template)).to eq(xen3)
      end

      it "does not select the node that already has the template provisioned" do
        expect(cluster.select_node(plan, template)).to_not eq(xen2)
      end
    end

    context "when the node is locked" do
      before { xen2.update_attributes locked: true }

      it "doesn't select the node" do
        expect(cluster.select_node(plan)).to_not eq(xen2)
      end
    end
  end
end