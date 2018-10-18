require 'spec_helper'

describe Solus::ServerSynchronizationTask do
  subject { described_class.new }

  context "with an active server" do
    let!(:server) { create :solus_server, state: :active, synchronize_at: Time.zone.now - 1.hour }

    it "enqueues a synchronization job for the server" do
      expect(Delayed::Job).to receive(:enqueue).with(instance_of(Solus::ServerSynchronizationJob))

      subject.perform
    end
  end

  context "with a server that doesn't require synchronization" do
    let!(:server) { create :solus_server, state: :active }

    it "does not enqueue a synchronization job for the server" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Solus::ServerSynchronizationJob))

      subject.perform
    end
  end

  context "with an inactive server" do
    let!(:server) { create :solus_server, state: :pending_confirmation }

    it "does not enqueue a synchronization job for the server" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Solus::ServerSynchronizationJob))

      subject.perform
    end
  end
end