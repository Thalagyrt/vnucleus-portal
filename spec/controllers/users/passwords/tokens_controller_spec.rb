require 'spec_helper'

describe Users::Passwords::TokensController do
  describe "#new" do
    before { get :new }

    it "assigns @token_form" do
      expect(assigns(:token_form)).to be_present
    end
  end

  context "without a valid user" do
    describe "#create" do
      before { post :create, token_form: { email: 'derpy@betaforce.com' } }

      it "assigns @token_form" do
        expect(assigns(:token_form)).to be_present
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end
  end

  context "with a valid user" do
    let!(:user) { create :user }

    describe "#create" do
      before { post :create, token_form: { email: user.email } }

      it "redirects to the home page" do
        expect(response).to redirect_to(root_path)
      end

      it "sends an email" do
        expect(last_email.subject).to match("Password reset instructions")
      end
    end
  end

  context "with a logged in user" do
    let(:user) { create :user }

    before { sign_in user }

    describe "#new" do
      before { get :new }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end

    describe "#create" do
      before { post :create, token_form: { email: 'derpy@betaforce.com' } }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end
  end
end