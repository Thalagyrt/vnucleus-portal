require 'spec_helper'

describe Solus::ServerSuspensionService do
  let(:cluster) { double(:solus_cluster) }
  let(:server) { double(:solus_server, vserver_id: 1, cluster: cluster) }
  let(:mailer_service) { double(:mailer_service) }
  let(:event_logger) { double(:event_logger) }
  let(:api_client) { double(:api_client) }
  subject { described_class.new(server: server, api_client: api_client, mailer_service: mailer_service, event_logger: event_logger) }

  before { allow(server).to receive(:with_lock) { |&b| b.call } }
  before { allow(event_logger).to receive(:log) }
  before { allow(event_logger).to receive(:with_entity).and_return(event_logger) }
  before { allow(event_logger).to receive(:with_category).and_return(event_logger) }

  describe "#automation_suspend" do
    context "when the server is able to be suspended" do
      before { allow(server).to receive(:state_events).and_return([:automation_suspend]) }
      before { allow(server).to receive(:automation_suspend) }
      before { allow(api_client).to receive(:api_command).with('vserver-suspend', anything) { |&b| b.call } }
      before { allow(mailer_service).to receive(:server_suspended) }

      it "marks the server suspended" do
        expect(server).to receive(:automation_suspend)

        subject.automation_suspend
      end

      it "logs an account event" do
        expect(event_logger).to receive(:log).with(:server_suspended)

        subject.automation_suspend
      end

      it "sends an email" do
        expect(mailer_service).to receive(:server_suspended)

        subject.automation_suspend
      end
    end

    context "when the server is not able to be suspended" do
      before { allow(server).to receive(:state_events).and_return([:provision]) }

      it "returns false" do
        expect(subject.automation_suspend).to be_falsey
      end
    end
  end

  describe "#admin_suspend" do
    context "when the server is able to be suspended" do
      before { allow(server).to receive(:state_events).and_return([:admin_suspend]) }
      before { allow(server).to receive(:admin_suspend) }
      before { allow(api_client).to receive(:api_command).with('vserver-suspend', anything) { |&b| b.call } }
      before { allow(mailer_service).to receive(:server_suspended) }

      it "marks the server suspended" do
        expect(server).to receive(:admin_suspend)

        subject.admin_suspend
      end

      it "logs an account event" do
        expect(event_logger).to receive(:log).with(:server_suspended)

        subject.admin_suspend
      end

      it "sends an email" do
        expect(mailer_service).to receive(:server_suspended)

        subject.admin_suspend
      end
    end

    context "when the server is not able to be suspended" do
      before { allow(server).to receive(:state_events).and_return([:provision]) }

      it "returns false" do
        expect(subject.admin_suspend).to be_falsey
      end
    end
  end

  describe "#unsuspend" do
    context "when the server is able to be suspended" do
      before { allow(server).to receive(:state_events).and_return([:unsuspend]) }
      before { allow(server).to receive(:unsuspend) }
      before { allow(api_client).to receive(:api_command).with('vserver-unsuspend', anything) { |&b| b.call } }
      before { allow(mailer_service).to receive(:server_unsuspended) }
      before { allow(server).to receive(:update_attributes) }

      it "marks the server suspended" do
        expect(server).to receive(:unsuspend)

        subject.unsuspend
      end

      it "logs an account event" do
        expect(event_logger).to receive(:log).with(:server_unsuspended)

        subject.unsuspend
      end

      it "sends an email" do
        expect(mailer_service).to receive(:server_unsuspended)

        subject.unsuspend
      end

      it "clears the suspension reason" do
        expect(server).to receive(:update_attributes).with hash_including(suspension_reason: nil)

        subject.unsuspend
      end
    end

    context "when the server is not able to be unsuspended" do
      before { allow(server).to receive(:state_events).and_return([:provision]) }

      it "returns false" do
        expect(subject.unsuspend).to be_falsey
      end
    end
  end
end