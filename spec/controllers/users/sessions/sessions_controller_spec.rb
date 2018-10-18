require 'spec_helper'

describe Users::Sessions::SessionsController do
  context "without a logged in user" do
    describe "#new" do
      it "assigns @session_form" do
        get :new

        expect(assigns(:session_form)).to be_present
      end
    end

    describe "#create" do
      let(:user) { create :user }

      context "with valid credentials" do
        it "assigns the user id to the session" do
          post :create, session_form: { email: user.email, password: user.password }

          expect(session[:user_id]).to eq(user.id)
        end

        context "when a return url is set" do
          let(:return_to) { new_users_account_path }
          before { session[:return_to] = return_to }

          it "redirects to the return url" do
            post :create, session_form: { email: user.email, password: user.password }

            expect(response).to redirect_to(return_to)
          end
        end

        context "when the user is staff" do
          let(:user) { create :staff_user }

          it "redirects to the admin dashboard" do
            post :create, session_form: { email: user.email, password: user.password }

            expect(response).to redirect_to(admin_dashboard_path)
          end
        end

        context "when the user has an account count other than one" do
          it "redirects to the account selector" do
            post :create, session_form: { email: user.email, password: user.password }

            expect(response).to redirect_to(users_accounts_path)
          end
        end

        context "when the user has only one account" do
          let(:user) { create :user_with_account }
          let(:account) { user.accounts.first }

          it "redirects to the account" do
            post :create, session_form: { email: user.email, password: user.password }

            expect(response).to redirect_to(users_account_path(account))
          end
        end
      end

      context "with invalid credentials" do
        it "assigns @session_form" do
          post :create, session_form: { email: user.email, password: 'herpderpin' }

          expect(assigns(:session_form)).to be_present
        end

        it "renders the new template" do
          post :create, session_form: { email: user.email, password: 'herpderpin' }

          expect(response).to render_template(:new)
        end
      end
    end

    describe "#destroy" do
      it "redirects to root" do
        delete :destroy

        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "with a logged in user" do
    let(:user) { create :user }
    before { sign_in user }

    describe "#new" do
      it "redirects away" do
        get :new

        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirects away" do
        post :create, session_form: { email: user.email, password: user.password }

        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "unsets the session" do
        delete :destroy

        expect(session[:user_id]).to be_nil
      end

      it "redirects to root" do
        delete :destroy

        expect(response).to redirect_to(root_path)
      end
    end
  end
end