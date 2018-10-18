require 'spec_helper'

describe Solus::ServerTerminationService do
  let(:vserverid) { 5 }
  let(:cluster) { double(:solus_cluster).as_null_object }
  let(:node) { double(:node, available_ram: 2.gigabytes, available_disk: 2.terabytes).as_null_object }
  let(:server) { double(:solus_server, node: node, cluster: cluster, vserver_id: vserverid, ram: 512.megabytes, disk: 25.gigabytes, ip_address_list: ['10.255.255.1']).as_null_object }
  let(:cluster_synchronization_job) { double(:cluster_synchronization_job) }
  let(:usage_updater_job) { double(:usage_updater_job) }
  let(:api_client) { double(:api_client) }
  let(:event_logger) { double(:event_logger) }
  let(:reverse_dns_updater_class) { double(:reverse_dns_updater_class) }
  let(:reverse_dns_updater) { double(:reverse_dns_updater, rate_limit_sleep: 0) }
  let(:assignment_klass) { double(:assignment_klass) }

  subject { described_class.new(server: server, cluster_synchronization_job: cluster_synchronization_job,
                                usage_updater_job: usage_updater_job, api_client: api_client, event_logger: event_logger,
                                reverse_dns_updater_class: reverse_dns_updater_class, assignment_klass: assignment_klass) }

  before { allow(server).to receive(:with_lock) { |&b| b.call } }
  before { allow(event_logger).to receive(:with_entity).and_return(event_logger) }
  before { allow(event_logger).to receive(:with_category).and_return(event_logger) }
  before { allow(event_logger).to receive(:log) }
  before { allow(reverse_dns_updater_class).to receive(:new).and_return(reverse_dns_updater) }
  before { allow(reverse_dns_updater).to receive(:has_mapping?).and_return(true) }
  before { allow(reverse_dns_updater).to receive(:destroy) }
  before { allow(assignment_klass).to receive(:record_usage) }

  describe "#terminate" do
    context "when successful" do
      before do
        allow(server).to receive(:can_terminate?).and_return(true)
        allow(api_client).to receive(:api_command).with('vserver-checkexists', anything) { true }
        allow(api_client).to receive(:api_command).with('vserver-terminate', anything) { |&b| b.call }
        allow(Delayed::Job).to receive(:enqueue).with(cluster_synchronization_job)
        allow(Delayed::Job).to receive(:enqueue).with(usage_updater_job)
      end

      it "marks the server terminated" do
        expect(server).to receive(:terminate)

        subject.terminate
      end

      it "records final IP usage" do
        expect(assignment_klass).to receive(:record_usage).with(server, server.ip_address_list.first)

        subject.terminate
      end

      it "records an event" do
        expect(event_logger).to receive(:log).with(:server_terminated)

        subject.terminate
      end

      it "removes reverse dns entries" do
        expect(reverse_dns_updater).to receive(:destroy)

        subject.terminate
      end

      it "synchronizes the node" do
        expect(Delayed::Job).to receive(:enqueue).with(cluster_synchronization_job)

        subject.terminate
      end

      it "updates template usage" do
        expect(Delayed::Job).to receive(:enqueue).with(usage_updater_job)

        subject.terminate
      end

      it "returns true" do
        expect(subject.terminate).to be_truthy
      end
    end

    context "when the server doesn't exist in solusvm" do
      before do
        allow(server).to receive(:can_terminate?).and_return(true)
        allow(api_client).to receive(:api_command).with('vserver-checkexists', anything) { false }
        allow(Delayed::Job).to receive(:enqueue).with(cluster_synchronization_job)
        allow(Delayed::Job).to receive(:enqueue).with(usage_updater_job)
      end

      it "marks the server terminated" do
        expect(server).to receive(:terminate)

        subject.terminate
      end

      it "records an event" do
        expect(event_logger).to receive(:log).with(:server_terminated)

        subject.terminate
      end

      it "synchronizes the node" do
        expect(Delayed::Job).to receive(:enqueue).with(cluster_synchronization_job)

        subject.terminate
      end

      it "updates template usage" do
        expect(Delayed::Job).to receive(:enqueue).with(usage_updater_job)

        subject.terminate
      end

      it "returns true" do
        expect(subject.terminate).to be_truthy
      end
    end

    context "when the server termination fails" do
      before do
        allow(api_client).to receive(:api_command).with('vserver-checkexists', anything) { true }
        allow(api_client).to receive(:api_command).with('vserver-terminate', anything).and_return(false)
      end

      it "returns false" do
        expect(subject.terminate).to be_falsey
      end
    end

    context "when the server is not terminatable" do
      before do
        allow(server).to receive(:can_terminate?).and_return(false)
      end

      it "returns false" do
        expect(subject.terminate).to be_falsey
      end
    end
  end
end