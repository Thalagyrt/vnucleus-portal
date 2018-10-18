require 'spec_helper'

describe Solus::ClusterSynchronizationJob do
  let(:cluster) { double(:cluster) }
  let(:cluster_synchronization_service) { double(:cluster_synchronization_service)}
  subject { described_class.new(cluster: cluster, cluster_synchronization_service: cluster_synchronization_service) }

  it "synchronizes the cluster" do
    expect(cluster_synchronization_service).to receive(:synchronize)

    subject.perform
  end
end