require 'spec_helper'

describe Users::Authenticated::Accounts::Solus::Servers::TransferGraphsController do
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

    describe "#show" do
      let(:cluster) { create :solus_cluster }
      let(:server) { create :solus_server, account: account }
      let(:body) { "leet haxin" }

      before { stub_solus_request('vserver-infoall', {vserverid: server.vserver_id}, double({success?: true, trafficgraph: 'test.txt'})) }

      before do
        stub_request(:get, "https://#{cluster.hostname}:5656/test.txt").
            to_return(:status => 200, :body => body, :headers => {'Content-Type' => 'text/plain'})
      end

      it "returns the image data" do
        get :show, account_id: account.to_param, server_id: server.to_param

        expect(response.body).to eq(body)
      end
    end
  end
end