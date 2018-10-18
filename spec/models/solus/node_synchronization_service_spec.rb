require 'spec_helper'

describe Solus::NodeSynchronizationService do
  let(:cluster) { double(:cluster) }
  let(:node) { double(:node, cluster: cluster).as_null_object }
  let(:api_client) { double(:api_client) }
  subject { described_class.new(node: node, api_client: api_client) }

  describe "#synchronize" do
    let(:response) { double(:response, ip: '10.0.0.1', nodegroupname: 'HDD', hostname: 'xen1', freeips: 5, freeipv6: 500).as_null_object }
    before { allow(api_client).to receive(:api_command).with('node-statistics', anything).and_yield(response) }
    before { allow(cluster).to receive(:update_attributes) }

    it "updates the node" do
      expect(node).to receive(:update_attributes).with(hash_including(
          ip_address: response.ip,
          hostname: response.hostname,
          node_group: response.nodegroupname,
          available_ipv4: response.freeips,
          available_ipv6: response.freeipv6,
      ))

      subject.synchronize
    end
  end
end