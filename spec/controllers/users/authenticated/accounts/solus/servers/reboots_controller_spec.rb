require 'spec_helper'

describe Users::Authenticated::Accounts::Solus::Servers::RebootsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1, server_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
    let(:server) { create :solus_server, account: account }
    let(:request_options) { { server_id: server.to_param } }
  end

  context "with a valid account" do
    let(:user) { create :user_with_account }
    let(:account) { user.accounts.first }

    before { sign_in user }

    context "when the user has server access" do
      context "and a server that is active" do
        let(:server) { create :solus_server, account: account, state: :active }

        before { stub_solus_request('vserver-reboot', {vserverid: server.vserver_id}, double(success?: true)) }

        describe "#create" do
          it "redirects to the server" do
            post :create, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_server_url(account, server))
          end
        end
      end

      context "and a server that is not active" do
        let(:server) { create :solus_server, account: account, state: :automation_terminated }

        describe "#create" do
          it "redirects to the server" do
            post :create, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_server_url(account, server))
          end
        end
      end
    end

    context "when the user does not have server access" do
      let(:server) { create :solus_server, account: account, state: :active }

      before { account.memberships.first.update_attribute :roles, [:manage_billing] }

      describe "#create" do
        it "renders a 404" do
          post :create, account_id: account.to_param, server_id: server.to_param

          expect(response.response_code).to eq(404)
        end
      end
    end
  end
end