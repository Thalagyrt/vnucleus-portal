require 'spec_helper'

describe Admin::Accounts::CreditsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:request_options) { { account_id: 1 } }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    before { sign_in user }

    describe "#new" do
      before { get :new, account_id: account.to_param }

      it "assigns @transaction_form" do
        expect(assigns(:transaction_form)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        before { post :create, account_id: account.to_param, transaction_form: { amount_dollars: '5', description: 'Sudden credit' } }

        it "adjusts the account balance" do
          expect(account.reload.balance).to eq(-500)
        end

        it "redirects to the account statement index" do
          expect(response).to redirect_to(admin_account_statements_path(account))
        end
      end

      context "with invalid data" do
        before { post :create, account_id: account.to_param, transaction_form: { amount_dollars: '0', description: 'Zero credit' } }

        it "assigns @transaction_form" do
          expect(assigns(:transaction_form)).to be_present
        end

        it "renders the new template" do
          expect(response).to render_template(:new)
        end
      end
    end
  end
end