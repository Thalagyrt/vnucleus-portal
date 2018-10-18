require 'spec_helper'

describe Solus::ServerAutomationUnsuspensionJob do
  let(:server) { double(:server) }
  let(:server_suspension_service) { double(:server_suspension_service) }

  subject do
    described_class.new(server: server, server_suspension_service: server_suspension_service)
  end

  before { allow(server_suspension_service).to receive(:unsuspend).and_return(true) }
  before { allow(server).to receive(:update_attribute) }

  it "suspends the server" do
    expect(server_suspension_service).to receive(:unsuspend)

    subject.perform
  end
end