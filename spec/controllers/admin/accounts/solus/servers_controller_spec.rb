require 'spec_helper'

describe Admin::Accounts::Solus::ServersController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:account) { create :account }
    let(:request_options) { { account_id: account.to_param } }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    let(:server) { create :solus_server, account: account }

    before { 3.times { create :solus_server, account: account }}
    before { sign_in user }

    describe "#index" do
      it "assigns @servers" do
        get :index, account_id: account.to_param

        expect(assigns(:servers)).to be_present
      end
    end

    describe "#show" do
      it "assigns @server" do
        get :show, account_id: account.to_param, id: server.to_param

        expect(assigns(:server)).to be_present
      end
    end

    describe "#edit" do
      it "assigns @server" do
        get :edit, account_id: account.to_param, id: server.to_param

        expect(assigns(:server)).to be_present
      end
    end

    describe "#update" do
      context "when the server is active" do
        before { allow(Delayed::Job).to receive(:enqueue) }

        it "schedules synchronization of the server" do
          expect(Delayed::Job).to receive(:enqueue).with(instance_of(Solus::ServerSynchronizationJob))

          put :update, account_id: account.to_param, id: server.to_param, server: { state: 'active' }
        end
      end
    end
  end
end