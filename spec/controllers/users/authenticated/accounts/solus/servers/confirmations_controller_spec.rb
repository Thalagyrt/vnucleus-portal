require 'spec_helper'

describe Users::Authenticated::Accounts::Solus::Servers::ConfirmationsController do
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
      context "and a server that is pending confirmation" do
        let(:server) { create :solus_server, account: account, state: :pending_confirmation }

        describe "#new" do
          it "assigns @server" do
            get :new, account_id: account.to_param, server_id: server.to_param

            expect(assigns(:server)).to eq(server)
          end
        end

        describe "#create" do
          before { allow(Delayed::Job).to receive(:enqueue) }

          it "redirects to the server" do
            post :create, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_server_url(account, server))
          end
        end

        describe "#delete" do
          it "redirects to the account's servers" do
            delete :destroy, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_servers_url(account))
          end
        end
      end

      context "and a server that is not pending confirmation" do
        let(:server) { create :solus_server, account: account, state: :active }

        describe "#new" do
          it "redirects to the server" do
            get :new, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_server_url(account, server))
          end
        end

        describe "#create" do
          it "redirects to the server" do
            post :create, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_server_url(account, server))
          end
        end

        describe "#delete" do
          it "redirects to the server" do
            delete :destroy, account_id: account.to_param, server_id: server.to_param

            expect(response).to redirect_to(users_account_solus_server_url(account, server))
          end
        end
      end
    end

    context "when the user doesn't have server access" do
      let(:server) { create :solus_server, account: account, state: :pending_confirmation }

      before { account.memberships.first.update_attribute :roles, [:manage_billing] }

      describe "#new" do
        it "renders a 404" do
          get :new, account_id: account.to_param, server_id: server.to_param

          expect(response.response_code).to eq(404)
        end
      end

      describe "#create" do
        it "renders a 404" do
          post :create, account_id: account.to_param, server_id: server.to_param

          expect(response.response_code).to eq(404)
        end
      end

      describe "#delete" do
        it "renders a 404" do
          delete :destroy, account_id: account.to_param, server_id: server.to_param

          expect(response.response_code).to eq(404)
        end
      end
    end
  end
end