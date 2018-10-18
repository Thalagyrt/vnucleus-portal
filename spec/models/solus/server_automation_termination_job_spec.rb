require 'spec_helper'

describe Solus::ServerAutomationTerminationJob do
  let(:server) { double(:server) }
  let(:server_termination_job) { double(:server_termination_job) }
  subject do
    described_class.new(
        server: server,
        server_termination_job: server_termination_job,
    )
  end

  before { allow(server).to receive(:update_attributes).and_return(true) }
  before { allow(Delayed::Job).to receive(:enqueue) }

  it "enqueues termination of the server" do
    expect(Delayed::Job).to receive(:enqueue).with(server_termination_job)

    subject.perform
  end

  it "clears the termination date" do
    expect(server).to receive(:update_attributes).with hash_including(terminate_on: nil)

    subject.perform
  end

  it "sets the cancellation reason to :payment_not_received" do
    expect(server).to receive(:update_attributes).with hash_including(termination_reason: :payment_not_received)

    subject.perform
  end
end