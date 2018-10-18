require 'spec_helper'

describe Accounts::AccountRejector do
  let(:server) { double(:server) }
  let(:active_server) { double(:active_server, provisioning?: false, account: double(:account), node: double(:node), cluster: double(:cluster)) }
  let(:ticket) { double(:ticket) }
  let(:user) { double(:user) }
  let(:account) { double(:account, can_reject?: true, pending_solus_servers: [server], current_solus_servers: [active_server], open_tickets: [ticket], users: [user]) }
  let(:stripe_card_service) { double(:stripe_card_service) }
  let(:mailer_service) { double(:mailer_service) }
  let(:event_logger) { double(:event_logger) }

  subject { described_class.new(account: account, stripe_card_service: stripe_card_service, event_logger: event_logger, mailer_service: mailer_service) }

  before { allow(account).to receive(:with_lock) { |&b| b.call } }

  before { allow(event_logger).to receive(:log) }
  before { allow(stripe_card_service).to receive(:delete) }
  before { allow(account).to receive(:reject!) }
  before { allow(server).to receive(:cancel_order!) }
  before { allow(user).to receive(:ban!) }
  before { allow(active_server).to receive(:reject!) }
  before { allow(ticket).to receive(:update_attributes) }
  before { allow(Delayed::Job).to receive(:enqueue) }
  before { allow(mailer_service).to receive(:account_rejected) }

  let(:server_termination_job) { double(:job) }
  before { allow(Solus::ServerTerminationJob).to receive(:new).with(server: active_server).and_return(server_termination_job) }
  let(:resolve_incident_job) { double(:resolve_incident_job) }
  before { allow(Tickets::ResolveIncidentJob).to receive(:new).with(ticket: ticket).and_return(resolve_incident_job) }

  describe "#reject" do
    context "when preconditions are met" do
      it "cancels any pending servers" do
        expect(server).to receive(:cancel_order!)

        subject.reject
      end

      it "emails the account users" do
        expect(mailer_service).to receive(:account_rejected)

        subject.reject
      end

      it "rejects active servers" do
        expect(active_server).to receive(:reject!)

        subject.reject
      end

      it "schedules termination of active servers" do
        expect(Delayed::Job).to receive(:enqueue).with server_termination_job

        subject.reject
      end

      it "rejects the account" do
        expect(account).to receive(:reject!)

        subject.reject
      end

      it "closes open tickets" do
        expect(ticket).to receive(:update_attributes).with hash_including(status: :closed)

        subject.reject
      end

      it "schedules resolution of open tickets" do
        expect(Delayed::Job).to receive(:enqueue).with resolve_incident_job

        subject.reject
      end

      it "deletes the credit card" do
        expect(stripe_card_service).to receive(:delete)

        subject.reject
      end

      it "bans the account's users" do
        expect(user).to receive(:ban!)

        subject.reject
      end

      it "logs an event" do
        expect(event_logger).to receive(:log).with(:account_rejected)

        subject.reject
      end

      it "publishes success" do
        expect { subject.reject }.to publish_event(subject, :reject_success)
      end
    end

    context "when the account has a provisioning server" do
      before { allow(active_server).to receive(:provisioning?).and_return(true) }

      it "publishes failure" do
        expect { subject.reject }.to publish_event(subject, :reject_failure)
      end
    end
  end
end