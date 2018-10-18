require 'spec_helper'

describe Solus::ServerProvisionJob do
  let(:server) { double(:server, id: 1, provision_id: '1234', template: double(:template), account: double(:account), install_time: 60) }
  let(:server_provision_service) { double(:server_provision_service) }
  let(:completion_service) { double(:completion_service) }

  subject do
    described_class.new(
        server: server,
        server_provision_service: server_provision_service,
        completion_service: completion_service,
    )
  end

  context "when the server is pending provision" do
    before { allow(server_provision_service).to receive(:provision).and_return(true) }
    before { allow(server).to receive(:autocomplete_provision?).and_return(false) }
    before { allow(server).to receive(:provision_duration).and_return(10) }
    before { allow(server.template).to receive(:log_install_time) }
    before { allow(Delayed::Job).to receive(:enqueue) }

    it "provisions the server" do
      expect(server_provision_service).to receive(:provision)

      subject.perform
    end

    context "when the server is autocompletable" do
      before { allow(server).to receive(:autocomplete_provision?).and_return(true) }

      it "enqueues completion of the server" do
        expect(Delayed::Job).to receive(:enqueue).with(instance_of(Solus::ServerProvisionCompletionJob), run_at: anything)

        subject.perform
      end
    end

    context "when the server doesn't become active" do
      before { allow(server).to receive(:autocomplete_provision?).and_return(false) }

      it "enqueues a completion checking job" do
        expect(Delayed::Job).to receive(:enqueue).with(instance_of(Solus::ServerProvisionCompletionCheckingJob), run_at: anything)

        subject.perform
      end
    end
  end

  it "allows five attempts" do
    expect(subject.max_attempts).to eq(5)
  end
end