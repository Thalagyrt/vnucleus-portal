require 'spec_helper'

describe Users::Authenticated::InvitesController do
  let(:account) { create :account }
  let(:invite) { create :invite, account: account }

  context "with a registered user" do
    let(:user) { create :user }

    before { sign_in user }

    describe "#show" do
      before { get :show, token: invite.token }

      it "adds the user to the account's memberhips" do
        expect(account.memberships.find_by(user: user)).to be_present
      end

      it "redirects to the account" do
        expect(response).to redirect_to(users_account_path(account))
      end
    end
  end

  context "with an anonymous user" do
    describe "#show" do
      before { get :show, token: invite.token }

      it "redirects to the sign-in form" do
        expect(response).to redirect_to(new_users_registration_path)
      end
    end
  end
end