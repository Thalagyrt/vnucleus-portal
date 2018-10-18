require 'spec_helper'

describe Provisioning::ParametersController do
  describe "#show" do
    context "when there's a server pending completion with the remote IP" do
      let!(:server) { create :solus_server, ip_address: '0.0.0.0', state: :pending_completion }

      before { get :show, format: :json }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "assigns @server" do
        expect(assigns(:server)).to eq(server)
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