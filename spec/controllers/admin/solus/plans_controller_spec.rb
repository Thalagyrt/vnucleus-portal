require 'spec_helper'

describe Admin::Solus::PlansController do
  it_behaves_like "a protected user controller"

  it_behaves_like "a protected admin controller" do
    let(:resource) { create :solus_plan }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }

    before { sign_in user }

    describe "#index" do
      before { 3.times { create :solus_plan } }

      it "assigns @plans" do
        get :index

        expect(assigns(:plans)).to be_present
      end
    end

    describe "#new" do
      it "assigns @plan" do
        get :new

        expect(assigns(:plan)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        it "redirects away from the form" do
          post :create, plan: attributes_for(:solus_plan)

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @plan" do
          post :create, plan: attributes_for(:solus_plan).merge(name: '')

          expect(assigns(:plan)).to be_present
        end

        it "renders the new template" do
          post :create, plan: attributes_for(:solus_plan).merge(name: '')

          expect(response).to render_template(:new)
        end
      end
    end

    describe "#edit" do
      let(:plan) { create :solus_plan }

      it "assigns @plan" do
        get :edit, id: plan.id

        expect(assigns(:plan)).to be_present
      end
    end

    describe "#update" do
      let(:plan) { create :solus_plan }

      context "with valid data" do
        it "redirects away from the form" do
          put :update, id: plan.id, plan: attributes_for(:solus_plan)

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @plan" do
          put :update, id: plan.id, plan: attributes_for(:solus_plan).merge(name: '')

          expect(assigns(:plan)).to be_present
        end

        it "renders the edit template" do
          put :update, id: plan.id, plan: attributes_for(:solus_plan).merge(name: '')

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end