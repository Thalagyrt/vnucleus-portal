require 'spec_helper'

describe Admin::PaymentsController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    let(:payment) { create :transaction_payment, account: account }
    before { sign_in user }

    describe "#index" do
      it "assigns @transactions" do
        get :index

        expect(assigns(:transactions)).to include(payment)
      end
    end
  end
end