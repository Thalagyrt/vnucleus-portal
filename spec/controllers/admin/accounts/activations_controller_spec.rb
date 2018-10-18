require 'spec_helper'

describe Admin::Accounts::ActivationsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:request_options) { { account_id: 1 } }
  end

  context "with an admin user" do
    let!(:user) { create :staff_user }

    before { sign_in user }

    context "with an active account" do
      let(:account) { create :account }

      describe "#create" do
        it "renders a 404" do
          post :create, account_id: account.to_param

          expect(response.response_code).to eq(404)
        end
      end
    end

    context "with a valid account" do
      let(:account) { create :account, state: :pending_activation }

      describe "#create" do
        it "redirects to the account" do
          post :create, account_id: account.to_param

          expect(response).to redirect_to(admin_account_path(account))
        end

        it "marks the account active" do
          expect {
            post :create, account_id: account.to_param
          }.to change {
            account.reload.state
          }.to('active')
        end
      end

      describe "#destroy" do
        let(:customer) { double(:customer).as_null_object }
        before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }

        it "redirects to the account" do
          delete :destroy, account_id: account.to_param

          expect(response).to redirect_to(admin_account_path(account))
        end

        it "marks the account rejected" do
          expect {
            delete :destroy, account_id: account.to_param
          }.to change {
            account.reload.state
          }.to('rejected')
        end
      end
    end
  end
end