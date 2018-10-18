require 'spec_helper'

describe Solus::ClusterSynchronizationService do
  let(:cluster) { double(:cluster).as_null_object }
  let(:node_synchronization_service_class) { double(:node_synchronization_service_class) }
  let(:node_synchronization_service) { double(:node_synchronization_service) }
  let(:api_client) { double(:api_client) }
  subject { described_class.new(cluster: cluster, node_synchronization_service_class: node_synchronization_service_class, api_client: api_client) }

  before { allow(node_synchronization_service_class).to receive(:new).and_return(node_synchronization_service) }

  describe "#synchronize" do
    let(:response) { double(:response, nodes: 'Xen1,Xen2') }
    before { allow(api_client).to receive(:api_command).with('listnodes', anything).and_return(response) }

    let(:node_response) { double(:node_response, freeips: 5, freeipv6: 500) }
    before { allow(node_synchronization_service).to receive(:synchronize) }

    it "prunes the nodes" do
      expect(cluster).to receive(:prune_nodes)

      subject.synchronize
    end

    it "synchronizes each node" do
      expect(node_synchronization_service).to receive(:synchronize).twice

      subject.synchronize
    end
  end
end