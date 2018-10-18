require 'spec_helper'

describe Admin::Accounts::NotesController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:request_options) { { account_id: 1 } }
  end
end