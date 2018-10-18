require 'spec_helper'

describe Users::Authenticated::Accounts::TicketsController do
  it_behaves_like "a protected user controller" do
    let(:request_options) { { account_id: 1 } }
  end

  it_behaves_like "a protected account controller" do
    let(:account) { create :account }
    let(:resource) { create :ticket, account: account }
  end

  context "with a valid account" do
    let!(:user) { create :user_with_account }
    let(:account) { user.accounts.first }
    let!(:tickets) { 3.times.map { create :ticket, account: account } }

    before do
      sign_in user
    end

    describe "#index" do
      it "assigns @tickets" do
        get :index, account_id: account.to_param

        expect(assigns(:tickets)).to be_present
      end
    end

    describe "#show" do
      it "assigns @ticket" do
        get :show, account_id: account.to_param, id: tickets.first.to_param

        expect(assigns(:ticket)).to be_present
      end
    end

    describe "#new" do
      it "assigns @ticket_form" do
        get :new, account_id: account.to_param

        expect(assigns(:ticket_form)).to be_present
      end

      context "with a rejected account" do
        before { account.update_attributes state: :rejected }

        it "renders 404" do
          get :new, account_id: account.to_param

          expect(response.status).to eq(404)
        end
      end
    end

    describe "#create" do
      context "with a rejected account" do
        before { account.update_attributes state: :rejected }

        it "renders 404" do
          post :create, account_id: account.to_param, ticket_form: { subject: 'Help', body: 'Halp' }

          expect(response.status).to eq(404)
        end
      end

      context "with a valid ticket" do
        it "emails the account users" do
          expect_any_instance_of(Accounts::MailerService).to receive(:ticket_created)

          post :create, account_id: account.to_param, ticket_form: { subject: 'Help', body: 'Halp' }
        end

        it "emails the staff users" do
          expect_any_instance_of(Admin::MailerService).to receive(:ticket_created)

          post :create, account_id: account.to_param, ticket_form: { subject: 'Help', body: 'Halp' }
        end

        it "redirects away from the form" do
          post :create, account_id: account.to_param, ticket_form: { subject: 'Help', body: 'Halp' }

          expect(response).to be_redirect
        end
      end

      context "with an invalid ticket" do
        it "assigns @ticket_form" do
          post :create, account_id: account.to_param, ticket_form: { subject: '', body: '' }

          expect(assigns(:ticket_form)).to be_present
        end

        it "renders the new template" do
          post :create, account_id: account.to_param, ticket_form: { subject: '', body: '' }

          expect(response).to render_template(:new)
        end
      end
    end
  end
end