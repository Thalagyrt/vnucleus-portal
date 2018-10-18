require 'spec_helper'

describe Admin::Accounts::Solus::Servers::UnsuspensionsController do
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

    context "and a server that is suspended" do
      let(:server) { create :solus_server, account: account, state: :automation_suspended }

      before { stub_solus_request('vserver-unsuspend', {vserverid: server.vserver_id}, double(success?: true)) }

      describe "#create" do
        it "redirects to the server" do
          post :create, account_id: account.to_param, server_id: server.to_param

          expect(response).to redirect_to(admin_account_solus_server_url(account, server))
        end

        it "unsuspends the server" do
          expect { post :create, account_id: account.to_param, server_id: server.to_param }.to change { server.reload.state }.to('active')
        end
      end
    end

    context "and a server that is not suspended" do
      let(:server) { create :solus_server, account: account, state: :active }

      describe "#create" do
        it "redirects to the server" do
          post :create, account_id: account.to_param, server_id: server.to_param

          expect(response).to redirect_to(admin_account_solus_server_url(account, server))
        end
      end
    end
  end
end