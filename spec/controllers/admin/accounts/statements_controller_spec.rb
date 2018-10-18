require 'spec_helper'

describe Admin::Accounts::StatementsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:request_options) { { account_id: 1 } }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }

    before do
      sign_in user
    end

    context "without a valid account" do
      describe "#index" do
        it "renders a 404" do
          get :index, account_id: 1

          expect(response.response_code).to eq(404)
        end
      end

      describe "#show" do
        it "renders a 404" do
          get :show, account_id: 1, id: '2014-01'

          expect(response.response_code).to eq(404)
        end
      end
    end

    context "with a valid account" do
      let(:account) { create :account }
      let!(:transactions) { 3.times.map { create :transaction, account: account } }

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
end