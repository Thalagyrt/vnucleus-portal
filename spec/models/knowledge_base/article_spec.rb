require 'spec_helper'

describe KnowledgeBase::Article do
  describe ".published" do
    let!(:draft) { create :draft_knowledge_base_article }
    let!(:published) { create :published_knowledge_base_article }

    it "includes published articles" do
      expect(KnowledgeBase::Article.published).to include(published)
    end

    it "does not include draft articles" do
      expect(KnowledgeBase::Article.published).to_not include(draft)
    end
  end
end