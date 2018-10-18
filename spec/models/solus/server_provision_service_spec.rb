require 'spec_helper'

describe Solus::ServerProvisionService do
  let(:node) { double(:node, available_ram: 2.gigabytes, available_disk: 2.terabytes).as_null_object }
  let(:cluster) { double(:solus_cluster, select_node: node).as_null_object }
  let(:account) { double(:account, id: 1, long_id: 'xyzpdq', name: 'Super Duper Account') }
  let(:template) { double(:template, generate_root_password?: false) }
  let(:server) { double(:solus_server, hostname: 'test.vnucleus.com', account: account, cluster: cluster, template: template, ram: 512.megabytes, disk: 25.gigabytes).as_null_object }
  let(:cluster_synchronization_job_class) { double(:cluster_synchronization_job_class) }
  let(:cluster_synchronization_job) { double(:cluster_synchronization_job) }
  let(:server_synchronization_job_class) { double(:server_synchronization_job_class) }
  let(:server_synchronization_job) { double(:server_synchronization_job) }
  let(:usage_recorder_class) { double(:usage_recorder_class) }
  let(:usage_recorder) { double(:usage_recorder) }
  let(:api_client) { double(:api_client) }
  let(:event_logger) { double(:event_logger) }
  subject { described_class.new(server: server, cluster_synchronization_job_class: cluster_synchronization_job_class,
                                server_synchronization_job_class: server_synchronization_job_class,
                                usage_recorder_class: usage_recorder_class, api_client: api_client, event_logger: event_logger) }

  before { allow(usage_recorder_class).to receive(:new).and_return(usage_recorder) }
  before { allow(usage_recorder).to receive(:record) }
  before { allow(cluster_synchronization_job_class).to receive(:new).with(cluster: cluster).and_return(cluster_synchronization_job) }
  before { allow(server_synchronization_job_class).to receive(:new).with(server: server).and_return(server_synchronization_job) }
  before { allow(server).to receive(:with_lock) { |&b| b.call } }
  before { allow(event_logger).to receive(:with_entity).and_return(event_logger) }
  before { allow(event_logger).to receive(:with_category).and_return(event_logger) }
  before { allow(event_logger).to receive(:log) }

  describe "#provision" do
    before do
      allow(server).to receive(:node=).with(node) { allow(server).to receive(:node).and_return(node) }
      allow(Delayed::Job).to receive(:enqueue).with(cluster_synchronization_job)
      allow(Delayed::Job).to receive(:enqueue).with(server_synchronization_job)
    end

    context "when successful" do
      let(:vserverid) { 5 }
      let(:mainipaddress) { '127.0.0.1' }
      let(:root_password) { 'j2983x8y32jui' }
      before do
        allow(server).to receive(:can_provision?).and_return(true)
        allow(api_client).to receive(:api_command).with('client-create', anything) { |&b| b.call }
        allow(api_client).to receive(:api_command).with('vserver-create', anything) { |&b| b.call(double(vserverid: vserverid, mainipaddress: mainipaddress, rootpassword: root_password)) }
      end

      it "marks the server provisioned" do
        expect(server).to receive(:update_attributes).with hash_including(state_event: :provision)

        subject.provision
      end

      it "assigns the vserverid to the server" do
        expect(server).to receive(:update_attributes).with hash_including(vserver_id: vserverid)

        subject.provision
      end

      it "assigns the rootpassword to the server" do
        expect(server).to receive(:update_attributes).with hash_including(root_password: root_password)

        subject.provision
      end

      it "assigns the ip address to the server" do
        expect(server).to receive(:update_attributes).with hash_including(ip_address: mainipaddress)

        subject.provision
      end

      it "assigns the selected node to the server" do
        expect(server).to receive(:node=).with(node)

        subject.provision
      end

      it "records an event" do
        expect(event_logger).to receive(:log).with(:server_provisioned)

        subject.provision
      end

      it "synchronizes the cluster" do
        expect(Delayed::Job).to receive(:enqueue).with(cluster_synchronization_job)

        subject.provision
      end

      it "synchronizes the server" do
        expect(Delayed::Job).to receive(:enqueue).with(server_synchronization_job)

        subject.provision
      end

      it "records the template usage" do
        expect(usage_recorder).to receive(:record)

        subject.provision
      end

      it "returns true" do
        expect(subject.provision).to be_truthy
      end
    end

    context "when the server is not in a state that allows provision" do
      before { allow(server).to receive(:can_provision?).and_return(false) }

      it "returns false" do
        expect(subject.provision).to be_falsey
      end
    end

    context "when the server creation fails" do
      before do
        allow(api_client).to receive(:api_command).with('client-create', anything) { |&b| b.call }
        allow(api_client).to receive(:api_command).with('vserver-create', anything).and_return(false)
        allow(api_client).to receive(:api_command).with('client-delete', anything)
      end

      it "returns false" do
        expect(subject.provision).to be_falsey
      end

      it "deletes the client" do
        expect(api_client).to receive(:api_command).with('client-delete', anything)

        subject.provision
      end
    end

    context "when the client creation fails" do
      before do
        allow(api_client).to receive(:api_command).with('client-create', anything).and_return(false)
      end

      it "returns false" do
        expect(subject.provision).to be_falsey
      end
    end
  end
end