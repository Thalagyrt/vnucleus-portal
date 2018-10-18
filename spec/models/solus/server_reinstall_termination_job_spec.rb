require 'spec_helper'

describe Solus::ServerReinstallTerminationJob do
  let(:account) { double(:account) }
  let(:server) { double(:server, id: 1, prorated_amount: 100, next_due: Time.zone.today + 7.days, account: account, description: 'Server #1 (testy)') }
  let(:server_termination_service) { double(:server_termination_service) }
  let(:server_provision_job_class) { double :server_provision_job_class }
  let(:server_provision_job) { double(:server_provision_job) }

  before { allow(server_provision_job_class).to receive(:new).and_return(server_provision_job) }

  subject do
    described_class.new(
        server: server,
        server_termination_service: server_termination_service,
        server_provision_job_class: server_provision_job_class,
    )
  end

  context "when the server can be cancelled" do
    before { allow(server_termination_service).to receive(:terminate).and_return(true) }
    before { allow(Delayed::Job).to receive(:enqueue) }

    it "terminates the server" do
      expect(server_termination_service).to receive(:terminate)

      subject.perform
    end

    it "schedules the provision" do
      expect(Delayed::Job).to receive(:enqueue).with(server_provision_job, run_at: anything)

      subject.perform
    end
  end
end