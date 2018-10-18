require 'spec_helper'

describe Admin::Accounts::Solus::Servers::TerminationsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1, server_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:server) { create :solus_server }
    let(:request_options) { { account_id: server.account.to_param, server_id: server.to_param } }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }

    before { sign_in user }

    context "and a server that is active" do
      let(:server) { create :solus_server, account: account, state: :active }

      describe "#new" do
        it "assigns @server" do
          get :new, account_id: account.to_param, server_id: server.to_param

          expect(assigns(:server)).to be_present
        end
      end

      describe "#create" do
        before { allow(Delayed::Job).to receive(:enqueue) }

        it "redirects to the server" do
          post :create, account_id: account.to_param, server_id: server.to_param, server: { termination_reason: 'test' }

          expect(response).to redirect_to(admin_account_solus_server_url(account, server))
        end
      end
    end

    context "and a server that is not active" do
      let(:server) { create :solus_server, account: account, state: :automation_terminated }

      describe "#new" do
        it "redirects to the server" do
          get :new, account_id: account.to_param, server_id: server.to_param

          expect(response).to redirect_to(admin_account_solus_server_url(account, server))
        end
      end

      describe "#create" do
        it "redirects to the server" do
          post :create, account_id: account.to_param, server_id: server.to_param

          expect(response).to redirect_to(admin_account_solus_server_url(account, server))
        end
      end
    end
  end
end