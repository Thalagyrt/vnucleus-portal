require 'spec_helper'

describe Solus::ServerSynchronizationJob do
  let(:server) { create :solus_server, state: :active, used_transfer: 250.gigabytes }
  let(:node) { create(:solus_node) }
  let(:status) { double(node: node.name, ip_addresses: ['127.0.0.1'], used_transfer: 500.gigabytes, total_disk: 50.gigabytes, xen_id: 'vm0') }
  let(:status_service) { double(:status_service, status: status) }

  subject { described_class.new(server: server, status_service: status_service) }

  it "updates the node" do
    expect { subject.perform }.to change { server.node }.to(node)
  end

  it "updates the ip address" do
    expect { subject.perform }.to change { server.ip_address }.to('127.0.0.1')
  end

  it "schedules the next synchronization" do
    expect { subject.perform }.to change { server.synchronize_at }
  end

  it "updates the server's used transfer" do
    expect { subject.perform }.to change { server.used_transfer }.to(status.used_transfer)
  end

  it "updates the server's xen id" do
    expect { subject.perform }.to change { server.xen_id }.to(status.xen_id)
  end

  context "when the used transfer is less than the server's used transfer" do
    before { allow(status).to receive(:used_transfer).and_return(server.used_transfer - 100.gigabytes)}

    it "does not update the server's used transfer" do
      expect { subject.perform }.to_not change { server.used_transfer }
    end
  end
end