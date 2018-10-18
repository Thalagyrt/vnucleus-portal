require 'spec_helper'

describe Admin::Accounts::CreditCardsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected admin controller" do
    let(:request_options) { { account_id: 1 } }
  end

  context "with a valid account" do
    let!(:user) { create :staff_user }
    let(:account) { create :account }

    before do
      sign_in user
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

          expect(response).to redirect_to(edit_admin_account_credit_cards_path(account))
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
            address_zip: '31337', address_country: 'United States of America'
        }
      }

      context "with valid data" do
        let(:customer) { double(:customer).as_null_object }
        before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }

        it "redirects to the credit card" do
          put :update, account_id: account.to_param, credit_card: card_data

          expect(response).to redirect_to(admin_account_credit_cards_path(account))
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