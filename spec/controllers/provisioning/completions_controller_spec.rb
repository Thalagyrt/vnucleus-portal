require 'spec_helper'

describe Provisioning::CompletionsController do
  describe "#show" do
    context "when there's a server pending completion with the remote IP" do
      let(:user) { create :user_with_account }
      let(:account) { user.accounts.first }
      let!(:server) { create :solus_server, ip_address: '0.0.0.0', state: :pending_completion, account: account }

      before { get :show, format: :json }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "sends an email" do
        expect(last_email.subject).to eq("Server #{server.to_s} has been provisioned")
      end

      it "marks the server active" do
        expect(server.reload).to be_active
      end
    end

    context "when there's an active server with the remote IP" do
      let!(:server) { create :solus_server, ip_address: '0.0.0.0', state: :active }

      before { get :show, format: :json }

      it "returns 404" do
        expect(response.status).to eq(404)
      end
    end

    context "when there's no server with the remote IP" do
      before { get :show, format: :json }

      it "returns 404" do
        expect(response.status).to eq(404)
      end
    end
  end
end