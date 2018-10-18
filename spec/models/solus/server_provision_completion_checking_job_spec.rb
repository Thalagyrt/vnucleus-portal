require 'spec_helper'

describe Solus::ServerProvisionCompletionCheckingJob do
  let(:server) { double(:server, provision_id: '1234') }
  let(:provision_id) { server.provision_id }
  let(:mailer_service) { double(:mailer_service) }
  let(:pagerduty) { double(:pagerduty) }

  subject { described_class.new(server: server, provision_id: provision_id, mailer_service: mailer_service, pagerduty: pagerduty) }

  context "when the generation matches" do
    context "when the server is still provisioning" do
      before { allow(server).to receive(:provisioning?).and_return(true) }
      before { allow(mailer_service).to receive(:provision_stalled) }
      before { allow(pagerduty).to receive(:trigger) }

      it "sends the provision stalled email" do
        expect(mailer_service).to receive(:provision_stalled).with hash_including(server: server)

        subject.perform
      end

      it "triggers a pagerduty incident" do
        expect(pagerduty).to receive(:trigger)

        subject.perform
      end
    end
  end

  context "when the generation doesn't match" do
    let(:provision_id) { 'no match' }

    it "returns false" do
      expect(subject.perform).to be_falsey
    end
  end
end