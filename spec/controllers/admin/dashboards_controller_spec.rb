require 'spec_helper'

describe Admin::DashboardsController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    let(:ticket) { create :ticket, account: account }
    let!(:ticket_update) { create :ticket_update, ticket: ticket, user: user }
    before { sign_in user }

    describe "#show" do
      it "assigns @dashboard" do
        get :show

        expect(assigns(:dashboard)).to be_present
      end
    end
  end
end