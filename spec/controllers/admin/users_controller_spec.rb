require 'spec_helper'

describe Admin::UsersController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    before { sign_in user }

    describe "#index" do
      it "assigns @users" do
        get :index

        expect(assigns(:users)).to include(user)
      end
    end

    describe "#show" do
      it "assigns @user" do
        get :show, id: user.id

        expect(assigns(:user)).to eq(user)
      end
    end
  end
end