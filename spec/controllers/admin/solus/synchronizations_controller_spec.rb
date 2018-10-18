require 'spec_helper'

describe Admin::Solus::SynchronizationsController do
  it_behaves_like "a protected user controller" do
    let(:cluster) { create :solus_cluster }
    let(:request_options) { { cluster_id: cluster.id } }
  end

  it_behaves_like "a protected admin controller" do
    let(:cluster) { create :solus_cluster }
    let(:request_options) { { cluster_id: cluster.id } }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:cluster) { create :solus_cluster }

    before { sign_in user }
    before { allow(Delayed::Job).to receive(:enqueue).and_return(true) }

    describe "#create" do
      it "redirects to the cluster" do
        post :create, cluster_id: cluster.id

        expect(response).to redirect_to(admin_solus_cluster_url(cluster))
      end

      it "enqueues synchronization of the cluster" do
        expect(Delayed::Job).to receive(:enqueue).with instance_of(Solus::ClusterSynchronizationJob)

        post :create, cluster_id: cluster.id
      end
    end
  end
end