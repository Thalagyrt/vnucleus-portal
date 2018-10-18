require 'spec_helper'

describe Solus::ServerTransferNotificationTask do
  subject { described_class.new }

  context "with an active server" do
    let!(:server) { create :solus_server, state: :active }

    context "when the used bandwidth is greater than 75%" do
      before { server.update_attribute :used_transfer, server.transfer * 0.75 }

      it "enqueues a transfer notification job for the server" do
        expect(Delayed::Job).to receive(:enqueue).with(instance_of(Solus::ServerTransferNotificationJob))

        subject.perform
      end
    end

    context "when the used bandwidth is less than 75%" do
      before { server.update_attribute :used_transfer, server.transfer * 0.74 }

      it "does not enqueue a transfer notification job for the server" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Solus::ServerTransferNotificationJob))

        subject.perform
      end
    end
  end

  context "with an inactive server" do
    let!(:server) { create :solus_server, state: :pending_confirmation }

    context "when the used bandwidth is greater than 75%" do
      before { server.update_attribute :used_transfer, server.transfer * 0.75 }

      it "does not enqueue a transfer notification job for the server" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Solus::ServerTransferNotificationJob))

        subject.perform
      end
    end

    context "when the used bandwidth is less than 75%" do
      before { server.update_attribute :used_transfer, server.transfer * 0.74 }

      it "does not enqueue a transfer notification job for the server" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Solus::ServerTransferNotificationJob))

        subject.perform
      end
    end
  end
end