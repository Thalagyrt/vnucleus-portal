require 'spec_helper'

describe Users::Authenticated::Accounts::MembershipsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
    let(:resource) { create :membership, account: account }
  end

  context "with a valid account" do
    let!(:user) { create :user_with_account }
    let(:account) { user.accounts.first }

    before { sign_in user }

    context "when the account is pending billing information" do
      before { account.update_attributes state: :pending_billing_information }

      describe "#index" do
        it "renders 404" do
          get :index, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#edit" do
        let(:membership) { create :membership, account: account }

        it "renders 404" do
          get :edit, account_id: account.to_param, id: membership.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#update" do
        let(:membership) { create :membership, account: account }

        it "renders 404" do
          put :update, account_id: account.to_param, id: membership.to_param, membership: {}

          expect(response.status).to eq(404)
        end
      end
    end

    context "when the account is pending activation" do
      before { account.update_attributes state: :pending_activation }

      describe "#index" do
        it "renders 404" do
          get :index, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#edit" do
        let(:membership) { create :membership, account: account }

        it "renders 404" do
          get :edit, account_id: account.to_param, id: membership.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#update" do
        let(:membership) { create :membership, account: account }

        it "renders 404" do
          put :update, account_id: account.to_param, id: membership.to_param, membership: {}

          expect(response.status).to eq(404)
        end
      end
    end

    context "when the account is rejected" do
      before { account.update_attributes state: :rejected }

      describe "#index" do
        it "renders 404" do
          get :index, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#edit" do
        let(:membership) { create :membership, account: account }

        it "renders 404" do
          get :edit, account_id: account.to_param, id: membership.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#update" do
        let(:membership) { create :membership, account: account }

        it "renders 404" do
          put :update, account_id: account.to_param, id: membership.to_param, membership: {}

          expect(response.status).to eq(404)
        end
      end
    end

    describe "#index" do
      before { 3.times { create :membership, account: account } }

      it "assigns @invites" do
        get :index, account_id: account.to_param

        expect(assigns(:memberships)).to be_present
      end
    end

    context "and a different user" do
      let(:membership) { create :membership, account: account }

      describe "#edit" do
        it "assigns @membership" do
          get :edit, account_id: account.to_param, id: membership.to_param

          expect(assigns(:membership)).to be_present
        end
      end

      describe "#update" do
        it "redirects away from the form" do
          put :update, account_id: account.to_param, id: membership.to_param, membership: attributes_for(:membership)

          expect(response).to be_redirect
        end
      end

      describe "#destroy" do
        it "redirects back to memberships" do
          delete :destroy, account_id: account.to_param, id: membership.to_param

          expect(response).to be_redirect
        end
      end
    end

    context "and the logged in user" do
      let(:membership) { user.account_memberships.first }

      describe "#edit" do
        it "renders 404" do
          get :edit, account_id: account.to_param, id: membership.to_param

          expect(response.response_code).to eq(404)
        end
      end

      describe "#update" do
        it "enders 404" do
          put :update, account_id: account.to_param, id: membership.to_param, membership: attributes_for(:membership)

          expect(response.response_code).to eq(404)
        end
      end

      describe "#destroy" do
        it "enders 404" do
          delete :destroy, account_id: account.to_param, id: membership.to_param

          expect(response.response_code).to eq(404)
        end
      end
    end
  end
end