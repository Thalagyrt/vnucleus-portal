require 'spec_helper'

describe Users::Authenticated::Accounts::CreditCardsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
  end

  context "with a valid account" do
    let!(:user) { create :user_with_account }
    let(:account) { user.accounts.first }

    before do
      sign_in user
    end

    context "when the account is rejected" do
      before { account.update_attributes state: :rejected }

      describe "#show" do
        it "renders 404" do
          get :show, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#edit" do
        it "renders 404" do
          get :edit, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#update" do
        it "renders 404" do
          put :update, account_id: account.to_param, credit_card: {}

          expect(response.status).to eq(404)
        end
      end
    end

    context "when the account is pending activation" do
      before { account.update_attributes state: :pending_activation }

      describe "#show" do
        it "renders 404" do
          get :show, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#edit" do
        it "renders 404" do
          get :edit, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end

      describe "#update" do
        it "renders 404" do
          put :update, account_id: account.to_param, credit_card: {}

          expect(response.status).to eq(404)
        end
      end
    end

    context "when the account has a credit card on file" do
      let(:customer) { double(:customer).as_null_object }
      before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }

      describe "#show" do
        it "assigns @credit_card" do
          get :show, account_id: account.to_param

          expect(assigns(:credit_card)).to be_present
        end
      end

      describe "#edit" do
        it "assigns @credit_card" do
          get :edit, account_id: account.to_param

          expect(assigns(:credit_card)).to be_present
        end
      end
    end

    context "when the account doesn't have a credit card on file" do
      let(:customer) { double(:customer, active_card: nil).as_null_object }
      before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }

      describe "#show" do
        it "assigns @credit_card" do
          get :show, account_id: account.to_param

          expect(response).to redirect_to(edit_users_account_credit_cards_path(account))
        end
      end

      describe "#edit" do
        it "assigns @credit_card" do
          get :edit, account_id: account.to_param

          expect(assigns(:credit_card)).to be_present
        end
      end
    end

    describe "#update" do
      let(:card_data) {
        {
            token: 'tok_123', name: 'Derpy Bogsworth',
            address_line1: '123 Hayden Lane', address_city: 'Derpsville', address_state: 'Florida',
            address_zip: '31337', address_country: 'United States of America',
            expiration_month: '05', expiration_year: Time.zone.today.year + 1,
        }
      }

      context "with valid data" do
        let(:customer) { double(:customer, id: account.stripe_id).as_null_object }
        before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }

        context "when the account is pending its first server" do
          it "redirects to a new server page" do
            put :update, account_id: account.to_param, credit_card: card_data

            expect(response).to redirect_to(new_users_account_solus_server_path(account))
          end
        end

        context "when the account already has a server" do
          before { create :solus_server, account: account }

          it "redirects to the credit card" do
            put :update, account_id: account.to_param, credit_card: card_data

            expect(response).to redirect_to(users_account_credit_cards_path(account))
          end
        end
      end

      context "when the stripe data is invalid" do
        let(:customer) { double(:customer).as_null_object }
        before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }
        before { allow(customer).to receive(:save).and_raise(Stripe::InvalidRequestError.new(:test, :test)) }

        it "assigns @credit_card" do
          put :update, account_id: account.to_param, credit_card: card_data

          expect(assigns(:credit_card)).to be_present
        end

        it "renders the edit template" do
          put :update, account_id: account.to_param, credit_card: card_data

          expect(response).to render_template(:edit)
        end
      end

      context "with invalid data" do
        it "assigns @credit_card" do
          put :update, account_id: account.to_param, credit_card: card_data.except(:token)

          expect(assigns(:credit_card)).to be_present
        end

        it "renders the edit template" do
          put :update, account_id: account.to_param, credit_card: card_data.except(:token)

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end