require 'spec_helper'

describe Admin::AnalyticsController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }

    before { sign_in user }

    describe "#show" do
      it "assigns @analytics" do
        get :show

        expect(assigns(:analytics)).to be_present
      end
    end
  end
end