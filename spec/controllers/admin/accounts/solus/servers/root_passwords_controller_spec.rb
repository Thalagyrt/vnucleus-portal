require 'spec_helper'

describe Admin::Accounts::Solus::Servers::RootPasswordsController do
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
    let(:server) { create :solus_server, account: account }

    before { sign_in user }

    describe "#show" do
      it "assigns @server" do
        xhr :get, :show, account_id: account.to_param, server_id: server.to_param

        expect(assigns(:server)).to be_present
      end
    end
  end
end