require 'spec_helper'

describe Users::Authenticated::ProfilesController do
  it_behaves_like "a protected user controller"

  context "with a logged in user" do
    let(:password) { 'DerpHerpin123' }
    let(:user) { create :user, password: password }
    before { sign_in user }

    describe "#edit" do
      it "assigns @user" do
        get :edit

        expect(assigns(:user)).to be_present
      end
    end

    describe "#update" do
      context "with valid data" do
        it "redirects away from the form" do
          put :update, user: user.attributes.merge(first_name: 'Derpy', last_name: 'Bogsworth', current_password: password)

          expect(response).to be_redirect
        end

        it "updates the user" do
          put :update, user: user.attributes.merge(first_name: 'Derpy', last_name: 'Bogsworth', current_password: password)

          expect(user.reload.full_name).to eq('Derpy Bogsworth')
        end
      end

      context "with invalid data" do
        it "assigns @user" do
          put :update, user: user.attributes.merge(first_name: 'Derpy', last_name: 'Bogsworth')

          expect(assigns(:user)).to be_present
        end

        it "renders the edit template" do
          put :update, user: user.attributes.merge(first_name: 'Derpy', last_name: 'Bogsworth')

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end