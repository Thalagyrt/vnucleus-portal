require 'spec_helper'

describe Users::Authenticated::Accounts::Solus::Servers::StatusesController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1, server_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
    let(:server) { create :solus_server, account: account }
    let(:request_options) { { server_id: server.to_param } }
  end
end