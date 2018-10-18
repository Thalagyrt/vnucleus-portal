require 'spec_helper'

describe Solus::ServerAutomationSuspensionJob do
  let(:server) { double(:server) }
  let(:server_suspension_service) { double(:server_suspension_service) }

  subject do
    described_class.new(server: server, server_suspension_service: server_suspension_service)
  end

  before { allow(server_suspension_service).to receive(:automation_suspend).and_return(true) }
  before { allow(server).to receive(:update_attributes) }

  it "suspends the server" do
    expect(server_suspension_service).to receive(:automation_suspend)

    subject.perform
  end

  it "sets the suspension reason to :payment_not_received" do
    expect(server).to receive(:update_attributes).with hash_including(suspension_reason: :payment_not_received)

    subject.perform
  end

  it "clears the suspension date" do
    expect(server).to receive(:update_attributes).with hash_including(suspend_on: nil)

    subject.perform
  end
end