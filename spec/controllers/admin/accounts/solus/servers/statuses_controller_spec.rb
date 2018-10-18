require 'spec_helper'

describe Admin::Accounts::Solus::Servers::StatusesController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1, server_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:server) { create :solus_server }
    let(:request_options) { { account_id: server.account.to_param, server_id: server.to_param } }
  end
end