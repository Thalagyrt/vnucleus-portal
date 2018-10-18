require 'spec_helper'

describe Admin::TicketsController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    let(:ticket) { create :ticket, account: account }
    before { sign_in user }

    describe "#index" do
      it "assigns @tickets" do
        get :index

        expect(assigns(:tickets)).to include(ticket)
      end
    end
  end
end