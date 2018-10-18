require 'spec_helper'

describe Users::Authenticated::Accounts::InvitesController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
    let(:resource) { create :invite, account: account }
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

      describe "#new" do
        it "renders 404" do
          get :new, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#create" do
        it "renders 404" do
          post :create, account_id: account.to_param, invite: {}

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

      describe "#new" do
        it "renders 404" do
          get :new, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#create" do
        it "renders 404" do
          post :create, account_id: account.to_param, invite: {}

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

      describe "#new" do
        it "renders 404" do
          get :new, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#create" do
        it "renders 404" do
          post :create, account_id: account.to_param, invite: {}

          expect(response.status).to eq(404)
        end
      end
    end

    describe "#index" do
      before { 3.times { create :invite, account: account } }

      it "assigns @invites" do
        get :index, account_id: account.to_param

        expect(assigns(:invites)).to be_present
      end
    end

    describe "#new" do
      it "assigns @invite" do
        get :new, account_id: account.to_param

        expect(assigns(:invite)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        it "redirects away from the form" do
          post :create, account_id: account.to_param, invite: attributes_for(:invite)

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @invite" do
          post :create, account_id: account.to_param, invite: attributes_for(:invite).merge(email: '')

          expect(assigns(:invite)).to be_present
        end

        it "renders the new template" do
          post :create, account_id: account.to_param, invite: attributes_for(:invite).merge(email: '')

          expect(response).to render_template(:new)
        end
      end
    end

    describe "#destroy" do
      let(:invite) { create :invite, account: account }

      it "sets the invite's state to disabled" do
        expect { delete :destroy, account_id: account.to_param, id: invite.id }.to change { invite.reload.state }.to('disabled')
      end
    end
  end
end