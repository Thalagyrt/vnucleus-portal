require 'spec_helper'

describe Solus::ClusterSynchronizationTask do
  subject { described_class.new }
  let!(:cluster) { create :solus_cluster }

  it "enqueues a synchronization job for the cluster" do
    expect(Delayed::Job).to receive(:enqueue).with(instance_of(Solus::ClusterSynchronizationJob))

    subject.perform
  end
end