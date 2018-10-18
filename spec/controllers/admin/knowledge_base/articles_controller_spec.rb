require 'spec_helper'

describe Admin::KnowledgeBase::ArticlesController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    before { sign_in user }

    describe "#index" do
      let!(:articles) { 3.times.map { create :published_knowledge_base_article } }
      let!(:draft_article) { create :draft_knowledge_base_article }

      it "assigns @articles" do
        get :index

        expect(assigns(:articles)).to be_present
      end

      it "includes draft articles" do
        get :index

        expect(assigns(:articles)).to include(draft_article)
      end
    end

    describe "#show" do
      context "with a published article" do
        let!(:article) { create :published_knowledge_base_article }

        it "assigns @article" do
          get :show, id: article.id

          expect(assigns(:article)).to eq(article)
        end
      end

      context "with a draft article" do
        let!(:article) { create :knowledge_base_article }

        it "assigns @article" do
          get :show, id: article.id

          expect(assigns(:article)).to eq(article)
        end
      end
    end

    describe "#new" do
      it "assigns @article" do
        get :new

        expect(assigns(:article)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        it "redirects away from the form" do
          post :create, article: { title: 'Derp', body: 'herpin', summary: 'derpin', tag_list: 'noobs' }

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @article" do
          post :create, article: { title: '', body: 'herpin', summary: 'derpin', tag_list: 'noobs' }

          expect(assigns(:article)).to be_present
        end

        it "renders the new template" do
          post :create, article: { title: '', body: 'herpin', summary: 'derpin', tag_list: 'noobs' }

          expect(response).to render_template(:new)
        end
      end
    end

    describe "#edit" do
      let(:article) { create :knowledge_base_article }

      it "assigns @article" do
        get :edit, id: article.id

        expect(assigns(:article)).to be_present
      end
    end

    describe "#update" do
      let(:article) { create :knowledge_base_article }

      context "with valid data" do
        it "redirects away from the form" do
          put :update, id: article.id, article: { title: 'Derp', body: 'herpin', tag_list: 'noobs' }

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @article" do
          put :update, id: article.id, article: { title: '', body: 'herpin', tag_list: 'noobs' }

          expect(assigns(:article)).to be_present
        end

        it "renders the new template" do
          put :update, id: article.id, article: { title: '', body: 'herpin', tag_list: 'noobs' }

          expect(response).to render_template(:edit)
        end
      end
    end

    describe "#destroy" do
      let(:article) { create :knowledge_base_article }

      it "redirects to the article index" do
        delete :destroy, id: article.id

        expect(response).to be_redirect
      end
    end
  end
end