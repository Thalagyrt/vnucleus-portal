require 'spec_helper'

describe Admin::Solus::TemplatesController do
  it_behaves_like "a protected user controller"

  it_behaves_like "a protected admin controller" do
    let(:resource) { create :solus_template }
  end

  context "with an admin user" do
    let(:user) { create :staff_user }

    before { sign_in user }

    describe "#index" do
      before { 3.times { create :solus_template } }

      it "assigns @templates" do
        get :index

        expect(assigns(:templates)).to be_present
      end
    end

    describe "#new" do
      it "assigns @template" do
        get :new

        expect(assigns(:template)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        it "redirects away from the form" do
          post :create, template: attributes_for(:solus_template)

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @template" do
          post :create, template: attributes_for(:solus_template).merge(name: '')

          expect(assigns(:template)).to be_present
        end

        it "renders the new template" do
          post :create, template: attributes_for(:solus_template).merge(name: '')

          expect(response).to render_template(:new)
        end
      end
    end

    describe "#edit" do
      let(:template) { create :solus_template }

      it "assigns @template" do
        get :edit, id: template.id

        expect(assigns(:template)).to be_present
      end
    end

    describe "#update" do
      let(:template) { create :solus_template }

      context "with valid data" do
        it "redirects away from the form" do
          put :update, id: template.id, template: attributes_for(:solus_template)

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @template" do
          put :update, id: template.id, template: attributes_for(:solus_template).merge(name: '')

          expect(assigns(:template)).to be_present
        end

        it "renders the edit template" do
          put :update, id: template.id, template: attributes_for(:solus_template).merge(name: '')

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end