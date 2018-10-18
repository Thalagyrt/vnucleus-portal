require 'spec_helper'

describe Admin::AccountsController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    before { sign_in user }

    describe "#index" do
      it "assigns @accounts" do
        get :index

        expect(assigns(:accounts)).to include(account)
      end
    end

    describe "#show" do
      it "assigns @account" do
        get :show, id: account.to_param

        expect(assigns(:account)).to eq(account)
      end
    end

    describe "#edit" do
      it "assigns @account" do
        get :edit, id: account.to_param

        expect(assigns(:account)).to be_present
      end
    end

    describe "#update" do
      context "with valid params" do
        it "redirects to the account" do
          put :update, id: account.to_param, account: { entity_name: 'Testy' }

          expect(response).to be_redirect
        end
      end

      context "with invalid params" do
        it "redirects to the account" do
          put :update, id: account.to_param, account: { entity_name: '' }

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end