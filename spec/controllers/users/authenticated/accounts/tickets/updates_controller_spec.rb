require 'spec_helper'

describe Users::Authenticated::Accounts::Tickets::UpdatesController do
  it_behaves_like "a protected user controller", :update do
    let(:request_options) { { account_id: 1, ticket_id: 1 } }
  end

  it_behaves_like "a protected account controller", :update do
    let(:account) { create :account }
    let(:ticket) { create :ticket, account: account }
    let(:request_options) { { ticket_id: ticket.to_param } }
  end

  context "with an invalid ticket" do
    let(:user) { create :user_with_account }
    let(:account) { user.accounts.first }
    before { sign_in user }

    describe "#index" do
      it "renders 404" do
        xhr :get, :index, account_id: account.to_param, ticket_id: 1

        expect(response.response_code).to eq(404)
      end
    end

    describe "#create" do
      it "renders 404" do
        xhr :post, :create, account_id: account.to_param, ticket_id: 1

        expect(response.response_code).to eq(404)
      end
    end
  end

  context "with a valid ticket" do
    let(:user) { create :user_with_account }
    let(:account) { user.accounts.first }
    let(:ticket) { create :ticket, account: account }
    let!(:ticket_updates) { 3.times.map { create :ticket_update, ticket: ticket, user: user } }
    before { sign_in user }

    describe "#index" do
      it "assigns @updates" do
        xhr :get, :index, account_id: account.to_param, ticket_id: ticket.to_param

        expect(assigns(:updates)).to be_present
      end

      context "when a minimum sequence is given" do
        it "returns only items greater than or equal to the sequence number" do
          xhr :get, :index, account_id: account.to_param, ticket_id: ticket.to_param, minimum_sequence: 2

          assigns(:updates).each do |update|
            expect(update.sequence).to be >= 2
          end
        end
      end
    end

    describe "#new" do
      it "assigns @update" do
        xhr :get, :new, account_id: account.to_param, ticket_id: ticket.to_param

        expect(assigns(:update)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        it "emails the user" do
          xhr :post, :create, account_id: account.to_param, ticket_id: ticket.to_param, update: { body: 'Wewt, an update!', status: 2 }

          expect(last_email.body).to match("Wewt, an update!")
        end

        it "assigns @update" do
          xhr :post, :create, account_id: account.to_param, ticket_id: ticket.to_param, update: { body: 'Wewt, an update!', status: 2 }

          expect(assigns(:update)).to be_new_record
        end
      end

      context "with invalid data" do
        it "assigns @update" do
          xhr :post, :create, account_id: account.to_param, ticket_id: ticket.to_param, update: { body: '', status: 2 }

          expect(assigns(:update)).to be_new_record
        end

        it "renders the new template" do
          xhr :post, :create, account_id: account.to_param, ticket_id: ticket.to_param, update: { body: '', status: 2 }

          expect(response).to render_template(:new)
        end
      end
    end
  end
end