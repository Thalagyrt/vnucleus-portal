require 'spec_helper'

describe KnowledgeBase::ArticlesController do
  describe "#index" do
    let!(:articles) { 3.times.map { create :published_knowledge_base_article } }
    let!(:draft_article) { create :draft_knowledge_base_article }

    it "assigns @articles" do
      get :index

      expect(assigns(:articles)).to be_present
    end

    it "doesn't include unpublished articles in @articles" do
      get :index

      expect(assigns(:articles)).to_not include(draft_article)
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
      let!(:article) { create :draft_knowledge_base_article }

      it "renders 404" do
        get :show, id: article.id

        expect(response.response_code).to eq(404)
      end
    end
  end
end