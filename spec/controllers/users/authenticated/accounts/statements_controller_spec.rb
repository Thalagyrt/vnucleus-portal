require 'spec_helper'

describe Users::Authenticated::Accounts::StatementsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
  end

  context "with a valid account" do
    let!(:user) { create :user_with_account }
    let(:account) { user.accounts.first }
    let!(:transactions) { 3.times.map { create :transaction, account: account } }

    before do
      sign_in user
    end

    describe "#index" do
      it "assigns @statements" do
        get :index, account_id: account.to_param

        expect(assigns(:statements)).to be_present
      end
    end

    describe "#show" do
      it "assigns @statement" do
        get :show, account_id: account.to_param, id: transactions.first.created_at.strftime("%Y-%m")

        expect(assigns(:statement)).to be_present
      end
    end
  end
end