require 'spec_helper'

describe Users::Authenticated::Accounts::Solus::ServersController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
    let(:resource) { create :solus_server, account: account }
  end

  context "with a valid account" do
    let(:user) { create :user_with_account }
    let(:account) { user.accounts.first }
    let(:server) { create :solus_server, account: account }

    before { 3.times { create :solus_server, account: account }}
    before { sign_in user }

    context "when the user has server access" do
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
    end

    context "when the user doesn't have server access" do
      before { account.memberships.first.update_attribute :roles, [:manage_billing] }

      describe "#index" do
        it "renders a 404" do
          get :index, account_id: account.to_param

          expect(response.response_code).to eq(404)
        end
      end

      describe "#show" do
        it "renders a 404" do
          get :show, account_id: account.to_param, id: server.to_param

          expect(response.response_code).to eq(404)
        end
      end
    end
  end
end