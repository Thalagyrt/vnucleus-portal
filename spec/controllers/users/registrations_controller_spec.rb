require 'spec_helper'

describe Users::RegistrationsController do
  context "when the user isn't allowed to register" do
    describe "#new" do
      it "renders 404" do
        get :new

        expect(response.response_code).to eq(404)
      end
    end

    describe "#create" do
      it "renders 404" do
        post :create, user: attributes_for(:user)

        expect(response.response_code).to eq(404)
      end
    end
  end

  context "when the user is allowed to register" do
    before { session[:allow_registration] = true }

    context "when return_to isn't set" do
      describe "#new" do
        it "renders 404" do
          get :new

          expect(response.response_code).to eq(404)
        end
      end

      describe "#create" do
        it "renders 404" do
          post :create, user: attributes_for(:user)

          expect(response.response_code).to eq(404)
        end
      end
    end

    context "when return_to is set" do
      let(:return_to) { users_accounts_path }
      before { session[:return_to] = return_to }

      describe "#new" do
        it "assigns @user_form" do
          get :new

          expect(assigns(:user_form)).to be_present
        end
      end

      describe "#create" do
        let(:user_form_attributes) { attributes_for(:user) }

        context "with valid data" do
          it "redirects to the return path" do
            post :create, user_form: user_form_attributes

            expect(response).to redirect_to(return_to)
          end
        end

        context "with invalid data" do
          before { post :create, user_form: user_form_attributes.merge(email: '') }

          it "assigns @user_form" do
            expect(assigns(:user_form)).to be_present
          end

          it "renders the new template" do
            expect(response).to render_template(:new)
          end
        end

        context "when the email is taken" do
          let(:user) { create :user }
          before { post :create, user_form: user_form_attributes.merge(email: user.email) }

          it "assigns @user_form" do
            expect(assigns(:user_form)).to be_present
          end

          it "renders the new template" do
            expect(response).to render_template(:new)
          end
        end
      end
    end
  end
end