require 'spec_helper'

describe Users::Passwords::ResetsController do
  let(:user) { create :user }

  context "with a valid token" do
    describe "#new" do
      before { get :new, token: user.reset_token }

      it "assigns @reset_form" do
        expect(assigns(:reset_form)).to be_present
      end
    end

    describe "#create" do
      let(:password) { StringGenerator.password }

      context "with valid data" do
        before { post :create, token: user.reset_token, reset_form: { password: password, password_confirmation: password } }

        it "redirects to the root" do
          expect(response).to redirect_to(root_path)
        end

        it "changes the user's password" do
          expect(user.reload.authenticate(password)).to be_truthy
        end
      end

      context "with invalid data" do
        before { post :create, token: user.reset_token, reset_form: { password: password, password_confirmation: '' } }

        it "assigns @reset_form" do
          expect(assigns(:reset_form)).to be_present
        end

        it "renders the new template" do
          expect(response).to render_template(:new)
        end
      end
    end
  end

  context "when the user's password was changed since the token was created" do
    let!(:token) { user.reset_token }

    before { user.update_attributes password: 'derpherpin' }

    describe "#new" do
      before { get :new, token: token }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end

    describe "#create" do
      before { post :create, token: token, reset_form: { password: 'derpherpin', password_confirmation: 'derpherpin' } }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end
  end

  context "when the user's email was changed since the token was created" do
    let!(:token) { user.reset_token }

    before { user.update_attributes email: "oops_#{user.email}" }

    describe "#new" do
      before { get :new, token: token }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end

    describe "#create" do
      before { post :create, token: token, reset_form: { password: 'derpherpin', password_confirmation: 'derpherpin' } }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end
  end

  context "with a logged in user" do
    before { sign_in user }

    describe "#new" do
      before { get :new }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end

    describe "#create" do
      before { post :create, reset_form: { password: 'derpherpin', password_confirmation: 'derpherpin' } }

      it "renders 404" do
        expect(response.response_code).to eq(404)
      end
    end
  end
end